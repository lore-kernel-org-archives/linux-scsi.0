From: <Shyam_Iyer@Dell.com>
Subject: RE: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Mon, 28 Jan 2013 21:01:38 -0800
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D15707D75F2DD2@BLRX7MCDC203.AMER.DELL.COM>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
 <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
 <51011D2E.305@suse.de>
 <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
 <5106939E.1010301@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:53308 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3A2FLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 00:11:33 -0500
In-Reply-To: <5106939E.1010301@tributary.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jlinton@tributary.com, bart.vanassche@gmail.com
Cc: hare@suse.de, emilne@redhat.com, linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jeremy Linton
> Sent: Monday, January 28, 2013 10:05 AM
> To: Bart Van Assche
> Cc: Hannes Reinecke; Ewan D. Milne; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention
> handling
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/24/2013 8:38 AM, Bart Van Assche wrote:
> 
> > Let me ask this another way. SAN users expect that the LUN list at the
> > initiator side gets updated automatically after a SAN configuration change.
> > How should a SAN system communicate to a SCSI initiator that the LUN
> > list has been changed ? Some FC SAN systems send a LIP after a
> > configuration change to force the initiator to rescan LUNs. But how to
> 
> 	What I think your looking for is RSCN (Registered State Change
> notification) . Hook that, and then check the name server. This will tell you
> when ports get added/removed. You can then report luns against lun 0 of all
> the known target ports. This allows you to transparently detect changes.

iSNS based SCN registrations - Open iSCSI facilitates a subset of such SCNs.

http://linux.dell.com/files/presentations/Red_Hat_Summit_2009/Simplifying_Linux_iSCSI_management_with_iSNS-v0.7.pdf

Now if you want SCSI to do SCN registrations that will be a topic to discuss.. though I would say we don't go down that path..

Since both FC/FCoE and iSCSI can register with an iSNS/SNS server this should solve it atleast for the login/logout scenario.



