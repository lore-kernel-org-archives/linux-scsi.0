From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Mon, 17 Feb 2003 12:35:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E511D62.8040600@splentec.com>
References: <3E495862.3050709@splentec.com>	<20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com>	<20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com>	<20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com>	<20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com>	<20030213192440.A6660@redhat.com> <20030214165827.GA1165@beaverton.ibm.com>	 <3E4D44EB.1090402@splentec.com> <1045257640.1726.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> 
> I don't like this on several grounds:
> 
> 1. You have a really complex locking hierarchy.  It may be

Several LLDDs may get async event of a target appearing on
the fabric, thus you want to protect the scsi_portal::target_list
with a lock.

Several processes may be initiated who register a scsi_portal
with SCSI Core, thus you want to protect scsi_core::portal_list
with a lock.

The new void scsi_enqueue_cmd(struct scsi_command *) should
be *fully* reentrant, thus you want to protect the
struct scsi_lu::pending_cmd_q with a lock.

... unless you can serialize all those operations elsewhere,
which would be reminicent of the BKL...

-- 
Luben



