From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: need help diagnosing sym53c1010-33/Fujitstu MAN3367MP/raid1
 lockups
Date: Fri, 12 Jul 2002 04:19:12 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020712040821.R3673-100000@localhost.my.domain>
References: <1026253048.10874.16123.camel@palm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1026253048.10874.16123.camel@palm>
List-Id: linux-scsi@vger.kernel.org
To: Philip Hands <phil@hands.com>
Cc: linux-scsi@vger.kernel.org



On 9 Jul 2002, Philip Hands wrote:

> On Wed, 2002-07-10 at 02:23, G=E9rard Roudier wrote:
>
> > Now that we know that cable and terminators are ok, you may try, fo=
r
> > example, to lower the data transfer speed. This will reduce the str=
ess for
> > all the parts connected to the SCSI BUS and will allow more margin =
for
> > SCSI signaling. Result can give some new clue.
>
> I tried that before switching off the TCQ.
>
> It gave similar behaviour all the way down to 20MB/s (I may have trie=
d
> 10MB/s, but I'm not sure.  If I did, it didn't work either).

:(

I just tried to decode more carefully the driver messages your reported=
=2E
Some SCRIPTS intruction code values that have been read by the chip fro=
m
the on-chip RAM when the problem occurs seems weird to me.

The following patch should make the driver not use the on-chip RAM for
SCRIPTS for your controller, but some system RAM instead.

--- sym_hipd.c.orig	Sat Dec 29 22:58:58 2001
+++ sym_hipd.c	Fri Jul 12 04:06:41 2002
@@ -1363,12 +1363,12 @@
  ,
  {PCI_ID_LSI53C1010, 0x00, "1010-33", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFE=
N|
- FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
+ /*FE_RAM|FE_RAM8K|*/FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
  FE_C10}
  ,
  {PCI_ID_LSI53C1010, 0xff, "1010-33", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFE=
N|
- FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
+ /*FE_RAM|FE_RAM8K|*/FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
  FE_C10|FE_U3EN}
  ,
  {PCI_ID_LSI53C1010_2, 0xff, "1010-66", 6, 31, 7, 8,
------------------- CUT AT THIS PLACE -------------------------

You may apply this patch (/usr/src/linux/drivers/scsi/sym53c8xx_2/) and
let me know if it makes differences.

You also may try the driver with DMA MODE configuration option =3D 0.

Regards,
  G=E9rard.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
