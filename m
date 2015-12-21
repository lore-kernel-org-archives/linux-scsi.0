From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Mon, 21 Dec 2015 13:46:49 +0100
Message-ID: <20151221134649.293a1a1e@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-tape-owner@vger.kernel.org>
In-Reply-To: <20151218170644.24167419@harpe.intellique.com>
Sender: linux-tape-owner@vger.kernel.org
To: linux-tape@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Le Fri, 18 Dec 2015 17:06:44 +0100
Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:

>=20
> I'm trying to use mt to work with LTO-5 and bigger tapes. Switching
> partitions works:
>=20
> # tapeinfo -f /dev/sg1
> Product Type: Tape Drive
> Vendor ID: 'HP      '
> Product ID: 'Ultrium 5-SCSI  '
> Revision: 'Z61U'
> Attached Changer API: No
> SerialNumber: 'HU1249TP88'
> MinBlock: 1
> MaxBlock: 16777215
> SCSI ID: 1
> SCSI LUN: 0
> Ready: yes
> BufferedMode: yes
> Medium Type: Not Loaded
> Density Code: 0x58
> BlockSize: 0
> DataCompEnabled: yes
> DataCompCapable: yes
> DataDeCompEnabled: yes
> CompType: 0x1
> DeCompType: 0x1
> BOP: yes
> Block Position: 0
> Partition 0 Remaining Kbytes: 1459056
> Partition 0 Size in Kbytes: 1459056
> ActivePartition: 0
> EarlyWarningSize: 0
> NumPartitions: 1
> MaxPartitions: 1
> Partition0: 38
> Partition1: 1453
>=20
> # mt -f /dev/nst0 setpartition 1
>=20
>=20
> However "mt mkpartition" fails miserably:
>=20
> # mt -f /dev/nst0 mkpartition 1453
> /dev/nst0: Input/output error
>=20
> # dmesg | tail
> st 6:0:1:0: st0: Failed to read 65536 byte block with 256 byte
> transfer. st0: Sense Key : Illegal Request [current]=20
> st0: Add. Sense: Invalid field in parameter list
>=20
> Is this a limitation of mt or the st driver?
>=20

I'm replying to myself: this is very obviously a limitation of the st
driver. Checking st.c partition_tape() function, it looks like it only
knows of hardware from past century...=20

OTOH it seems that Cygwin does that properly... by using
CreateTapePartition, a windows kernel32.dll function. Argh. We'll have
to do the heavy lifting of SCSI commands by hand, then.

Where should we post an eventual patch, given that the linux-tape ML
looks like a ghost town? It would also be great to be able to support
more than 2 partitions (LTO-6 and 7 support 4), but that would require
patching the mt utility too, but I don't where it currently lives :)
Any hints welcome.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-tape" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
