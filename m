From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sun, 17 Nov 2013 18:54:34 -0500
Message-ID: <5289573A.9070307@interlog.com>
References: <527AF287.7020700@ubuntu.com>		 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>		 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>	 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>	 <52883CE9.9040102@ubuntu.com> <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com> <5288EBA6.3070609@ubuntu.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5288EBA6.3070609@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13-11-17 11:15 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> On 11/17/2013 01:43 AM, James Bottomley wrote:
>> OK, so three people have now told you that's not how the code
>> works. Why don't you just read it?  because there's not really much
>> point us reading your patches until you do.
>
> I have, which is why I said it handles it via scsi_eh_stu.  If I'm not
> understanding it correctly, then by all means, explain.

Even if the SCSI EH code does spin-up the disk,
it is inefficient and undesirable to send a device
into EH for what is a normal, predictable situation
(i.e. that a SCSI disk will need a START STOP UNIT
(start) command as part of a resume operation).

A big server machine could have thousands of SCSI
disks (many potentially virtual). Sending them all
into EH during a resume would be a really good
test for EH, but horrible for performance. If I was
designing the SCSI EH I would probably assume not
all disks would go into EH at roughly the same time.
Also if that many devices went into EH on the same
controller (HBA) it might be reasonable to assume
that the controller they share needs resetting.

Doug Gilbert


