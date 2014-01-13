From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/14] target/rd: Add DIF protection into rd_execute_rw
Date: Mon, 13 Jan 2014 11:22:10 -0800
Message-ID: <1389640930.5567.441.camel@haakon3.risingtidesystems.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-14-git-send-email-nab@daterainc.com>
	 <52CE7ABA.9080403@mellanox.com>
	 <1389336761.5567.403.camel@haakon3.risingtidesystems.com>
	 <52D28238.5010903@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50669 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaAMTUU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2014 14:20:20 -0500
In-Reply-To: <52D28238.5010903@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>

On Sun, 2014-01-12 at 13:53 +0200, Sagi Grimberg wrote:
> <SNIP>
> 
> >> I wander how we can skip  sbc_dif_verify_xxxx if the transport already
> >> offloaded DIF verify.
> >> I think that the transport should signal the core layer that it is able
> >> to offload DIF (ADD/STRIP/PASS/VERIFY), in which case the core should
> >> turn off the backstore DIF verify emulation to sustain performance.
> > So IBLOCK + PSCSI backends will need to be a non interleaved protection
> > PASS for fast path operation, and backend protection emulation is
> > reserved for RAMDISK and perhaps a special FILEIO full emulation mode.
> 
> But can't we avoid that if transport already verified? This will kill 
> performance.
> 

Sure, this will end up being configurable per backend if the fabric does
a CHECK + STRIP, or CHECK + PASS.

--nab



