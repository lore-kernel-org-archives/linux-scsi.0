From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Fri, 13 Jan 2017 16:56:27 +0100
Message-ID: <20170113155627.GD3409@linux-x5ow.site>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbdAMP4d (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Fri, 13 Jan 2017 10:56:33 -0500
Content-Disposition: inline
In-Reply-To: <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>

On Wed, Jan 11, 2017 at 08:13:02AM -0700, Jens Axboe wrote:
> On 01/11/2017 08:07 AM, Jens Axboe wrote:
> > On 01/11/2017 06:43 AM, Johannes Thumshirn wrote:
> >> Hi all,
> >>
> >> I'd like to attend LSF/MM and would like to discuss polling for block drivers.
> >>
> >> Currently there is blk-iopoll but it is neither as widely used as NAPI in the
> >> networking field and accoring to Sagi's findings in [1] performance with
> >> polling is not on par with IRQ usage.
> >>
> >> On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
> >> more block drivers and how to overcome the currently seen performance issues.
> > 
> > It would be an interesting topic to discuss, as it is a shame that blk-iopoll
> > isn't used more widely.
> 
> Forgot to mention - it should only be a topic, if experimentation has
> been done and results gathered to pin point what the issues are, so we
> have something concrete to discus. I'm not at all interested in a hand
> wavy discussion on the topic.

So here are my 1st real numbers on this topic w/ some spinning rust:

All is done with 4.10-rc3 and we at least have no performance degradation when
a poll budget of 128 or 256 (oddly the max that irq_poll currently does you
allow to have). Clearly it looks like the disk is the limiting factor here and
we already saturated it. I'll do AHCI SSD tests on Monday. Hannes did some tests 
with mptXsas and a SSD maybe he can share his findings as well.

scsi-sq:
--------
baseline:
  read : io=66776KB, bw=1105.5KB/s, iops=276, runt= 60406msec
  write: io=65812KB, bw=1089.6KB/s, iops=272, runt= 60406msec

AHCI irq_poll budget 31:
  read : io=53372KB, bw=904685B/s, iops=220, runt= 60411msec
  write: io=52596KB, bw=891531B/s, iops=217, runt= 60411msec

AHCI irq_poll budget 128:
  read : io=66664KB, bw=1106.4KB/s, iops=276, runt= 60257msec
  write: io=65608KB, bw=1088.9KB/s, iops=272, runt= 60257msec

AHCI irq_poll budget 256:
  read : io=67048KB, bw=1111.2KB/s, iops=277, runt= 60296msec
  write: io=65916KB, bw=1093.3KB/s, iops=273, runt= 60296msec

scsi-mq:
--------
baseline:
  read : io=78220KB, bw=1300.7KB/s, iops=325, runt= 60140msec
  write: io=77104KB, bw=1282.8KB/s, iops=320, runt= 60140msec

AHCI irq_poll budget 256:
  read : io=78316KB, bw=1301.7KB/s, iops=325, runt= 60167msec
  write: io=77172KB, bw=1282.7KB/s, iops=320, runt= 60167msec


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
