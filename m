From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: blocksize limitations in scsi tape driver (st) when used with
 DLT1 tape drives?
Date: Fri, 6 Sep 2002 00:28:35 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209060026320.1912-100000@kai.makisara.local>
References: <3D77C5C7.3010909@fl.priv.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kai.makisara.local ([62.248.131.85])
          by fep19-app.kolumbus.fi with ESMTP
          id <20020905212903.DDKZ7717.fep19-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Fri, 6 Sep 2002 00:29:03 +0300
In-Reply-To: <3D77C5C7.3010909@fl.priv.at>
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>

On Thu, 5 Sep 2002, Friedrich Lobenstock wrote:

> Dag Nygren wrote:
> > I have successfully been using Legato Networker with a
> > blocksize of 32k with my DLT here.
> >
> > But the way Legato wants to do it is to decide about the
> > blocksize itself.
> > This means that the driver should NOT decide on the BS, but
> > pass on anything written through it, meaning a blocksize setting
> > of 0 (or variable blocksize).
> >
> > Perhaps Arkeia works the same way ?
>
> I used variable blocksize (=0) before but then after about 3.5 gigs stored
> on the tape I get scsi-error and arkeia interprets this as end-of-tape.
>
> Aug  6 02:13:50 filesrv kernel: st0: Error with sense data: Info fld=0x2000, Deferred st09:00: sns = f1  3
> Aug  6 02:13:50 filesrv kernel: ASC=80 ASCQ= 1

The sense code 3 is MEDIUM ERROR. The ASC/ASCQ 80 01 is vendor specific.
In other words, you have bad tape (or the drive thinks that it is bad).
This is returned as an error in writing data to tape. Most applications
(hopefully) interpret this as end of tape.

	Kai


