From: Hannes Reinecke <hare@suse.de>
Subject: Re: LSI 1068e megasr propreitary driver and options
Date: Thu, 07 Aug 2008 14:02:10 +0200
Message-ID: <489AE442.2090504@suse.de>
References: <1213107996.28779.45.camel@ocean.blue.dmu.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:45950 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbYHGMdm (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2008 08:33:42 -0400
In-Reply-To: <1213107996.28779.45.camel@ocean.blue.dmu.ac.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Owen Williams <williams@dmu.ac.uk>
Cc: Linux-scsi@vger.kernel.org

Hi Owen,

Owen Williams wrote:
> Hello,
>   I have a SuperMicro 7045A-T with a 4 SAS drives connected to an on
> board LSI 1068e.  The only way I have found to install linux to see
> these drives is to use either RHEL or SLES and LSI's proprietary mesg=
asr
> driver.  Apparently the driver will only work with 2.6.19 and below.
>=20
> The driver:
>=20
> ftp://ftp.supermicro.com/driver/SAS/LSI/Driver/1068/SR/Linux/09.32_Re=
dHat5.zip
>=20
> Is this still the case?
>=20
> I see mention of 1068e in fusion drivers mptbase and mptsas but the/m=
y
> usual distros don't pick up the drives.  Is it possible that because =
the
> chip is labelled: 'Subsystem: Super Micro Computer Inc Unknown device
> a480' that installers can't cope?
>=20
No, that's because this HBA has a software RAID built-in which you can'=
t
even disable. So it will always try to write (and read) some metadata
off the disk and hence will be quite unhappy if the metadata was overwr=
itten,
eg by an installation.

However, the HBA itself is just a plain mptsas device, so an

echo 1000 0059 > /sys/bus/pci/drivers/mptsas/new_id

will make the (raw) disks appear.
And 'dmraid' knows the DDF1 metadata format used by this chip, so
you can easily install on the dmraid disk without the risk of
overwriting any metadata.

HTH,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
