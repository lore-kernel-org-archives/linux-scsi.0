From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 115351] New: redundant pointless messages
Date: Sun, 27 Mar 2016 20:49:47 -0400
Message-ID: <56F87FAB.1040907@interlog.com>
References: <bug-115351-11613@https.bugzilla.kernel.org/>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55844 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbcC1At5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2016 20:49:57 -0400
In-Reply-To: <bug-115351-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On 16-03-27 03:48 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=115351
>
>              Bug ID: 115351
>             Summary: redundant pointless messages
>             Product: IO/Storage
>             Version: 2.5
>      Kernel Version: All
>            Hardware: All
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: low
>            Priority: P1
>           Component: SCSI
>            Assignee: linux-scsi@vger.kernel.org
>            Reporter: spamme@ecybernard.com
>          Regression: No
>
> First, why does it have to log "Very big device" 44 times on startup.
> Second, Given the size of ALL modern hard drives an array of almost any size
> probably triggers this warning.

That will only occur if this function:

static int sd_try_rc16_first(struct scsi_device *sdp)
{
         if (sdp->host->max_cmd_len < 16)
                 return 0;
         if (sdp->try_rc_10_first)
                 return 0;
         if (sdp->scsi_level > SCSI_SPC_2)
                 return 1;
         if (scsi_device_protection(sdp))
                 return 1;
         return 0;
}

returns zero and the disks in question have more than 2**32 - 1
logical blocks. [For 512 byte blocks that is 2 TiB, for 4096 byte
blocks that is 16 TiB.] Modern SCSI (SAS) disks should be reporting
SPC-3 or higher compliance as should virtual disks in any properly
configured array.

> Suggestion:  just get rid of this pointless message.  Maybe you should just
> always use 16, or maybe for future proofing go to 24 or 32.

The 2**64 logical block maximum in the READ CAPACITY(16) response
should be sufficient, for the time being.

Request: find out why sd_try_rc16_first() returns zero.

Doug Gilbert

