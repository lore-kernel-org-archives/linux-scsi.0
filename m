From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] lio-target: Add support for libcrypto crc32c and
 crc32-intel offload
Date: Mon, 13 Sep 2010 11:21:27 +0200
Message-ID: <4C8DED17.6080801@suse.de>
References: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab0IMJVd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2010 05:21:33 -0400
In-Reply-To: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>Mike Christie <michaelc@cs.wisc.edu>, Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>

Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> Greetings all,
>=20
> This patch series converts the LIO-Target fabric module from using a =
legacy
> internal slicing by 1x CRC32C algorithm to the slicing by 1x CRC32C a=
vailable in
> crc32c.ko, as well as initial support for the Nehalem series crc32c-i=
ntel.ko
> instruction offload available since v2.6.27 in late 2008.
>=20
> So far this series has been lightly tested with a handful of Open-iSC=
SI client VMs
> with the optimized crc32c-intel.ko offload case, and there appears to=
 be some
> HeaderDigest failures for one case with RHEL6 B2 x86_64, while Ubuntu=
 i686 on
> v2.6.27 and OpenSuse 11.2 x86_64 on v2.6.31 work as expected with Hea=
derDigest=3DCRC32C
> and DataDigest=3DCRC32C using the offload on the LIO-Target side.
>=20
> Currently this patch disables the new iSCSI TPG attribute crc32c_x86_=
offload
> to force the crc32c.ko slicing by x1 CRC32C algorithm until these com=
patibility
> issues with existing libcrc32c clients can be properly resolved with =
the Nehalem
> CRC32C offload instructions running on the LIO-Target side.
>=20
Due to a customer issue I had to revisit the CRC32 issue recently.
And according to you the main reason for using your own CRC routines
had been endianness issues.
IE the in-kernel crc32c routines apparently weren't able to
calculate the checksum in an endianness-independent manner.
So a CRC calculated on a BE machine would fail to be validated by a
LE machine and vice versa.

Has this been fixed / verified?

Cheers,

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
