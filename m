From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Serial Console capture
Date: Sun, 21 May 2006 10:30:28 -0500
Message-ID: <1148225428.17239.11.camel@mulgrave.il.steeleye.com>
References: <BAY112-F171BA6C2D4226546E27C7EA0A50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11173 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964892AbWEUPab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 May 2006 11:30:31 -0400
In-Reply-To: <BAY112-F171BA6C2D4226546E27C7EA0A50@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mun Hamlet <hamletmun@hotmail.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2006-05-21 at 06:58 -0300, Mun Hamlet wrote:

> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0 
>         <Adaptec 29160 Ultra160 SCSI adapter> 
>         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs 
> 
>   Vendor: WDIGTL    Model: WD91 ULTRA2       Rev: 1.00 
>   Type:   Direct-Access                      ANSI SCSI revision: 02 
> scsi0:A:0:0: Tagged Queuing enabled.  Depth 32 
> target0:0:0: Beginning Domain Validation 
> target0:0:0: wide asynchronous 
> target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62) 
> 0:0:0:0: Write Buffer failure 8000002 
> target0:0:0: Domain Validation detected failure, dropping back 
> target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 62) 
> 0:0:0:0: Write Buffer failure 8000002 
> target0:0:0: Domain Validation detected failure, dropping back 
> target0:0:0: FAST-40 WIDE SCSI 66.0 MB/s DT (30.3 ns, offset 62) 
> 0:0:0:0: Write Buffer failure 8000002 
> target0:0:0: Domain Validation detected failure, dropping back 
> target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s DT (50 ns, offset 62) 
> 0:0:0:0: Write Buffer failure 8000002 
> target0:0:0: Domain Validation detected failure, dropping back 
> target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s DT (100 ns, offset 62) 
> (scsi0:A:0:0): parity error detected in Data-in phase.

This suggests to me that your bus is unstable in LVD mode.  Which must
be true, since your CD's are SE only.  There must be something rather
wrong in the bus set up, since the HBA loop test should have detected
the presence of SE devices and thus disallowed all LVD modes.

On the other hand, this is starting to sound familiar ... I've seen
discs before which try to report LVD requiring modes on a SE bus.
Perhaps the SPI class should be verifying signal type ... but before
that can happen, the aic7xxx would actually have to report signal type.

James


