From: "Sachin Mhatre \(smhatre\)" <smhatre@cisco.com>
Subject: RE: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 21:50:02 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com>
References: <20030924144817.A16189@infradead.org>
Reply-To: <smhatre@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:33351 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S261448AbTIXQUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 12:20:10 -0400
In-Reply-To: <20030924144817.A16189@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Hi,

1. We are using the following options in the indent command for handling
the 80 character limit:-
indent -kr -i8 -ts8 -sob -l80 -ss -bs -psl <filename>.c
However, this does not handle the log messages in double quotes. We will
manually take care of such messages.
2. The opening of files from kernel space is important for the iscsi
probing mechanism.
We read/write into the "/proc/scsi/scsi" file for
configuration/deconfiguration of iSCSI devices.
3. typedefs in our code will be removed. Kernel functions will be used
wherever available.
We will update you once the above mentioned changes are done.

Thanks,
Sachin 



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of 'Christoph
Hellwig'
Sent: Wednesday, September 24, 2003 7:18 PM
To: Sachin Mhatre (smhatre)
Cc: 'Jeff Garzik'; linux-scsi@vger.kernel.org
Subject: Re: [iscsi 2/2] iscsi-probe.c


On Wed, Sep 24, 2003 at 07:12:12PM +0530, Sachin Mhatre (smhatre) wrote:
> Hi,
> 	The linux-iscsi source code submitted for review is for
inclusion 
> into the 2.4 linux kernel tree. You can get this source code from the 
> linux-iscsi sourceforge branch with the tag "linux-iscsi-3-5-branch". 
> Just for convenience here is the cvs command for anonymous checkout of

> this code:- cvs 
> -d:pserver:anonymous@cvs.sourceforge.net:/cvsroot/linux-iscsi co -r 
> linux-iscsi-3-5-branch linux-iscsi .
> 
> We have tested this code on the Redhat Linux 9.0 platform, kernel 
> version 2.4.22.
> 
> Please let your valuable feedback pour in.

It looks like all comments I posted on linux-scsi apply to the
inux-iscsi-3-5-branch version of iscsi-probe.c, too.  So please stop
messing randomly with the namespace and opening files from kernelspace,
respect Documentation/CodingStyle (avoid typedefs, linebreaks after 80
chars, etc..) and try to use kernel functionality where available.

Note that I can't help you with redhat inclusion, but for mainline
inclusion we'd like to see a 2.6 version before a 2.4 one.  So my advice
would be to concentrate on 2.6 first, the scsi layer is much nicer
anyway there.  If that's done backport it to 2.4 which might require a
few bad workarounds and/or small changes to the scsi core.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

