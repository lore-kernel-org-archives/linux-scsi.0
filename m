From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187381] 4.9.-rc4 produces hundreds of unusable scsi devices.
Date: Wed, 09 Nov 2016 23:08:05 +0000
Message-ID: <bug-187381-11613-G09cKjAJkL@https.bugzilla.kernel.org/>
References: <bug-187381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754369AbcKIXII (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 18:08:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id B86B52038A
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2016 23:08:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 8309D2037C
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2016 23:08:05 +0000 (UTC)
In-Reply-To: <bug-187381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187381

--- Comment #3 from Samuel Flory Silbory <samuel.silbory@hds.com> ---
Seems sane now.
root@pcsnode:~# uname -a
Linux pcsnode 4.9.0-rc4-1-default #1 SMP Wed Nov 9 13:59:28 PST 2016 x86_64
GNU/Linux
root@pcsnode:~# ls /dev/sd*
/dev/sda  /dev/sdc  /dev/sde  /dev/sdg    /dev/sdi  /dev/sdk   /dev/sdk2   
/dev/sdk4  /dev/sdk6  /dev/sdl
/dev/sdb  /dev/sdd  /dev/sdf  /dev/sdh    /dev/sdj  /dev/sdk1  /dev/sdk3   
/dev/sdk5  /dev/sdk7  /dev/sdm
root@pcsnode:~# 

The only difference compared to 4.8/4/4 is the boot drive on the SATA
controller ended up sdk instead of sdm (the last drive).  It's not an issue for
me as I mount things by UUID

________________________________________
From: Samuel Silbory
Sent: Wednesday, November 09, 2016 1:19 PM
To: James Bottomley; bugzilla-daemon@bugzilla.kernel.org;
linux-scsi@vger.kernel.org
Subject: RE: [Bug 187381] New: 4.9.-rc4 produces hundreds of unusable scsi
devices.

Certainly I'll give it a try.
________________________________________
From: James Bottomley [James.Bottomley@HansenPartnership.com]
Sent: Wednesday, November 09, 2016 12:49 PM
To: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
Cc: Samuel Silbory
Subject: Re: [Bug 187381] New: 4.9.-rc4 produces hundreds of unusable scsi
devices.

On Wed, 2016-11-09 at 20:20 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D187381&d=CwICaQ&c=DZ-EF4pZfxGSU6MfABwx0g&r=4FOU_7YnNtQNKWSdicj67DITRyD0V0NPxX2P7qBxsr8&m=qqYheGXoM4mBPxyZZ7HM1rugSFukVAVfEjl1ifhaoqU&s=67orQXH1IekXCew60eHDOmksAqiZIU69q0eGzoqiWMM&e=
>
>             Bug ID: 187381
>            Summary: 4.9.-rc4 produces hundreds of unusable scsi
> devices.
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 4.9-rc4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>           Reporter: samuel.silbory@hds.com
>         Regression: No
>
> Created attachment 244091
>   -->
> https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_attachment.cgi-3Fid-3D244091-26action-3Dedit&d=CwICaQ&c=DZ-EF4pZfxGSU6MfABwx0g&r=4FOU_7YnNtQNKWSdicj67DITRyD0V0NPxX2P7qBxsr8&m=qqYheGXoM4mBPxyZZ7HM1rugSFukVAVfEjl1ifhaoqU&s=ypXf8FCNK77zZPf1gXuZlzQpRkGQWJ_WEGmWjqnXTOI&e=
> Debian's kernel log file.  Note that this contains functional boots
> with older
> kernels as well earlier in the file.
>
> With both my hand compiled 4.9-rc4 from kernel.org sources and
> Ubuntu's
> 4.9.0-040900rc4-generic the kernel creates hundred of useless
> /dev/sd??
> devices.  This system is fine with various 4.4, and 4.8 kernels.
>
> The logs are spammed with messages like these
> 2016-11-09T12:17:00.021765-08:00 Node001 kernel: [75590.503155] Dev
> sdjm:
> unable to read RDB block 1
> 2016-11-09T12:17:00.021767-08:00 Node001 kernel: [75590.503188]
>  sdjm: unable
> to read partition table
> 2016-11-09T12:17:00.021769-08:00 Node001 kernel: [75590.503191] sdjm:
> partition
> table beyond EOD, enabling native capacity
> 2016-11-09T12:17:00.021776-08:00 Node001 kernel: [75590.504463] sd
> 1:3:126:0:

This was reported to the mailing list and should be fixed by this:

https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.info_-3Fl-3Dlinux-2Dscsi-26m-3D147868920429684&d=CwICaQ&c=DZ-EF4pZfxGSU6MfABwx0g&r=4FOU_7YnNtQNKWSdicj67DITRyD0V0NPxX2P7qBxsr8&m=qqYheGXoM4mBPxyZZ7HM1rugSFukVAVfEjl1ifhaoqU&s=KCePcDLsNpEqob1iEoGGCb5Qf-smnMYk4XsK62Sp0h4&e=

We'll fast track this, but can you verify it fixes your issue.

Thanks,

James

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
