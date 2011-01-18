From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 26992] New: iscsi session re-establishment by client does
 not work (auth method rejected by target)
Date: Mon, 17 Jan 2011 18:26:18 -0600
Message-ID: <4D34DE2A.9090501@cs.wisc.edu>
References: <bug-26992-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37199 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1ARA0m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2011 19:26:42 -0500
In-Reply-To: <bug-26992-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On 01/17/2011 06:12 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=26992
>
>             Summary: iscsi session re-establishment by client does not work
>                      (auth method rejected by target)
>             Product: IO/Storage
>             Version: 2.5
>      Kernel Version:>=2.6.33
>            Platform: All
>          OS/Version: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: blocking
>            Priority: P1
>           Component: SCSI
>          AssignedTo: linux-scsi@vger.kernel.org
>          ReportedBy: bugzilla-kernel-org-sux2k0@mstier.de
>                  CC: bugzilla-kernel-org-sux2k0@mstier.de
>          Regression: No
>
>
> Latest client kernel version known to work: 2.6.32.27 (vanilla)
> First client kernel version known NOT to work: 2.6.33 (vanilla)
>
> I'm doing sanboot via iSCSI/TCP using gPXE 1.0.1 from etherboot.org. The gPXE
> chain boot loader registers the iSCSI target lun as boot disk and when the
> Ubuntu OS starts iscsid, session re-establishment fails when using kernel
> 2.6.33 or higher on the client (session startup configured as manual). Works
> perfectly with 2.6.32.27 on the client.
>

Are these kernel.org/open-iscsi.org open-iscsi tools ir distro build ones?

I think this is due to a sysfs issue. If I am right it should be fixed 
in 872 
(http://kernel.org/pub/linux/kernel/people/mnc/open-iscsi/releases/open-iscsi-2.0-872.tar.gz) 
or I think you can change the SYSFS DEPRECIATED and SYSFS V2 DEPRECIATED 
settings. I cannot remember if you need to turn it on or off (I think 
you need to turn it on with older tools). Send your .config.

Also could you send the log messages for when it fails? And does normal 
login work? If you just boot from a local drive and run iscsiadm to 
login does it fail? What is the error message and what is the 
/var/log/message output?
