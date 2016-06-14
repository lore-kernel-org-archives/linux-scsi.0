From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] 53c700: fix BUG on untagged commands
Date: Tue, 14 Jun 2016 09:15:49 +0200
Message-ID: <20160614071549.5hqvboown32cwe2o@c203.arch.suse.de>
References: <1465880407.18583.18.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465880407.18583.18.camel@linux.vnet.ibm.com>
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Parisc List <linux-parisc@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 13, 2016 at 10:00:07PM -0700, James Bottomley wrote:
> The untagged command case in the 53c700 driver has been broken since
> host wide tags were enabled because the replaced scsi_find_tag()
> function had a special case for the tag value SCSI_NO_TAG to retrieve
> sdev->current_cmnd.  The replacement function scsi_host_find_tag() ha=
s
> no such special case and returns NULL causing untagged commands to
> trigger a BUG() in the driver.  Inspection shows that the 53c700 is t=
he
> only driver using this SCSI_NO_TAG case, so a local fix in the driver
> suffices to fix this problem globally.
>=20
> Fixes: 64d513ac31b - "scsi: use host wide tags by default"
> Cc: stable@vger.kernel.org	# 4.4+
> Reported-by: Helge Deller <deller@gmx.de>
> Tested-by: Helge Deller <deller@gmx.de>
> Signed-off-by: James Bottomley <jejb@linux.vnet.ibm.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-parisc"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
