From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: Re: qla2xxx async scan in kernel 2.6.16
Date: Mon, 27 Apr 2009 16:39:02 +0800
Message-ID: <d364733c0904270139l4d21f364n8c4352dec133b541@mail.gmail.com>
References: <d364733c0904260904t1ba66e7ey1caef491d6428866@mail.gmail.com>
	 <1240766855.4627.2.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:44989 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbZD0IjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 04:39:02 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1730532rvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 01:39:02 -0700 (PDT)
In-Reply-To: <1240766855.4627.2.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Apr 27, 2009 at 1:27 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2009-04-27 at 00:04 +0800, =D0=BB=B8=D9 wrote:
>> In kernel 2.6.16, I find that there is no scsi_scan_host in
>> qla2xxx_probe_one. So how does the qla driver scan the scsi device?
>
> scsi_scan_host() is only really for non hotplug busses that need a fi=
xed
> id scan.
>
> Hotplug buses use scsi_scan_target() instead when the device appears =
on
> the bus.  Most do this (like fc) from the target port appearance via =
the
> allied transport class.
I got it. Thanks very much. qla calls qla2x00_update_fcport to update
the fc port. This will triger the scan of the target.
fc_scsi_scan_rport will be called in the work queue of the scsi host.
It scans the target with scsi_scan_target. So, it's actually the
scsi_wq_x thread who does the scan works. These worker threads contend
for the sd name.

I changed the qlogic hba to emulex. It's very strange that the sd
names were generated orderly. It looks like that there is no
contention among the worker threads when scan the target.



>
> James
>
>
>



--=20
Xie Gang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
