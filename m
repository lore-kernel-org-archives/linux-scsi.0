From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH-FOR-38] target: Fix READ_CAPACITY_16 regression
Date: Fri, 11 Mar 2011 17:17:35 -0600
Message-ID: <1299885455.6938.6.camel@mulgrave.site>
References: <1299109971-27268-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1299109971-27268-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ben Jarvis <bjarvismn@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-03-02 at 15:52 -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi James,
> 
> This patch fixes a regression for READ_CAPACITY to trigger SAI READ_CAPACITY_16 for
> >= 0xffffffff virtual backends.  This occured during v4.0.0-rc6 when the backend
> read_capacity* handlers where moved into generic target_core_cdb.c code, and the
> 'unsigned long long blocks_long' piece was dropped from target_emulate_readcapacity().
> 
> This fix has been tested with TCM_Loop on .38-rc7 with lio-4.1 and is working as expected
> with large block virtual backends:
> 
> [67826.897061] TARGET_CORE[loopback]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
> [67826.897061] scsi 7:0:1:0: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
> [67826.900933] sd 7:0:1:0: [sdd] 2621440000001 512-byte logical blocks: (1.34 PB/1.19 PiB)
> [67826.901510] sd 7:0:1:0: [sdd] Write Protect is off
> [67826.901684] sd 7:0:1:0: [sdd] Mode Sense: 2f 00 00 00
> 
> Please include into scsi-rc-fixes going to Linus for-38 mainline target code.

So the piece you didn't say is that this only affects volumes >2TB
volume which misreport the capacity (which is actually what the bug
description should have been).

That's hardly an oopsworthy fix at this stage ... I'll put it into misc
with a cc stable.

James
