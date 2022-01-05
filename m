Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CBDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 18:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242658AbiAESAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 13:00:49 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:34573 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242651AbiAESAq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 13:00:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1641405644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=twRWwg9SkXZv+Nn3cTZJmcMxP3sNgvmF/fM/hkEEZS4=;
        b=KyRID2NF6t95z21czq+40X3ZYbvv2rKY8xfyuxOKxgVg99AMwdai/dg6AaYa2AWfYSLog3
        oJEeXJ0vH6xW/mN6lm+W3ymv0IujxcEIwZy3BiqAbOTpMARR5y+3X+PWTv5W59AU2UQ8Wm
        +NK00y62mcad2kdeNmXFg5sYJHhcI9k=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2057.outbound.protection.outlook.com [104.47.1.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-14-mKu2LlI5OHO7calWEpXvpw-1; Wed, 05 Jan 2022 19:00:43 +0100
X-MC-Unique: mKu2LlI5OHO7calWEpXvpw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgTmX4OeR/RqOWRrhJmrJSPxzwkjXt8FHc/AaweCBHwCCLZa2q8XFA/T34kA2pvjApJLAwEF/VAID0pNykF56F6X9ABRJnh+EG2hs2AlC7EbnXRZ1Dmdj3rI58AetovQhaZovgMNpi1o86Cxb9coeGtB1JMztDVMEDuMwkeMebNye+ATgjLz5USUk3UIiadSbVSzaRh1cOBAKKwXKfj/Ysi59shI/nGEZWQlOU+2KN+F3R6m7baowYZqa6XuLyh9mwDU5Y+5grvkSuICBNuU+EHbpP3JKkCHV0Xpgsmg3TV/yIPvkOjBTUXYvaAYfbHzIFVi0NVnhFPRi2ourF6cmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twRWwg9SkXZv+Nn3cTZJmcMxP3sNgvmF/fM/hkEEZS4=;
 b=FAMZIYLus+fuIeKc1NU2jOtaQ+X/SySAX77z7woYp0eojwrVbHYTWi/5oSPHdldBsUcifhaXB9gF1LvzRqnR7HcsPqY2AajofWKTcRsoNTCsYceJTs9HMW2neIEOUgw6OEgwtS/qy2MK3MuwHVpwSkIDeGIt5pdc7sISxCTKvNT63sm8zz24X0JYVhI2b6ic57j3PBOgDNgMtgbfMmDtVX3vP78dJpunZ2PUA2jQ7NkbDa0MBO4tEbjuBvlvG3ypgDsfWOQRPXJVO0pNFlqJ823ST83xs6IuBJDhB5yCdWFT270Efshk8XijZ6CZudFV37b5lwaTNCu7DDH3Gh9kmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 18:00:42 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 18:00:41 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "hare@suse.de" <hare@suse.de>, Martin Wilck <martin.wilck@suse.com>
Subject: mpt3sas fails to allocate budget_map and detects no devices
Thread-Topic: mpt3sas fails to allocate budget_map and detects no devices
Thread-Index: AQHYAl4nMXu34/rIHUa9cQ2p6vlOuQ==
Date:   Wed, 5 Jan 2022 18:00:41 +0000
Message-ID: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85b7c2c2-299f-48a0-9bd3-08d9d07549f0
x-ms-traffictypediagnostic: DB8PR04MB6555:EE_
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-microsoft-antispam-prvs: <DB8PR04MB655548A5615975BEFC5E671DFC4B9@DB8PR04MB6555.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LbxoMDWcKVKQoDfWe4vO4FxWN1JGULiaVbZk962LxSz0qopVy6isV8jQlFMSJwAsY/Fs/FkcTbXOax/FL+Nc0TQ9qRSn+XhgxeZPgh1EJoKjBK2v2/zk0Ik+16+8ESSgicQybphZg5s4iczjEEMvcJdPXZWmXg3atbk31+5/kvJOUAw8+CQ6X6CbnRdBNw3sikrcVBgLZQ8Vqj1g7r3RAJNpFdP1yHmgyJhnq/hgLLlI3Cj7CwT/ph///gM2PBW3VJxrwhgkcFuqoQxeINZMcWnRkdmAIPJKF6ADVNN58dW5iNcAdRkp6p04Wyi0dQxcpKkD2iWU1I8REM21ms7ORSGMORqbYGthugtJBqw8nK6FhMU/gOzDbXUYO67MYJTkkM99QWjsf81RLeoEFb7OYob6brrYojvGHuuNinFYiWiq3Z/QaIdGJti40JiFzt7VV5KjIYxv7XE2cI7BQDk/JSQETScHaMxdXdLKUnMFrn78l1DODg+c6sxaJrXOalUISE+x9EbmYt4DiKkkQ31E0bZJu4ssB9U65Ndz9KUU6y3kFu2GvBOL91P8fbbqRoyAixq0NqUrHrVEwqyRHIzhCuWL9yEBwLKbNE95cWMA7LP6PiYw+vqJhKtxN0v9JaFiQXR/Et69iYpMuxTxpS+IuU+npb9RcIrRzm3DmAyFCXpyekDVrlFI/REj7dkKDIwC3AUYoZOXotpUYmI6tbvPKmtOi0blX4LUUKbBjhlKj6g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(8676002)(83380400001)(8936002)(508600001)(38070700005)(4326008)(71200400001)(110136005)(66476007)(66556008)(6486002)(66446008)(38100700002)(122000001)(91956017)(66946007)(107886003)(316002)(64756008)(76116006)(2906002)(6512007)(26005)(5660300002)(36756003)(44832011)(86362001)(186003)(54906003)(2616005)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?KDSoz3W9rmUVncNP1upaO5eJTyvhXp1MouZNSDwF/72uL79FRbpypE6gd?=
 =?iso-8859-15?Q?x/abfoHJ+5/6cfYg9vLnp2jhgS0gMMSWcksBLSJbMIdxQG8zWVawLcwab?=
 =?iso-8859-15?Q?zunpxeFRQem3Of55sGnGYBzMg7mWqmDBF+ppZvQoWRV+7fm/0e9i8nWU8?=
 =?iso-8859-15?Q?UyXitWliSBFr44UvISL821s1laSo4oyFcm9RuJoVINw1QUOckfBl55gWN?=
 =?iso-8859-15?Q?fQyApXMziPbd+TnA5gKD94FcnBa0TeBP7pSakimLEzr6/FaxgmsXuND3l?=
 =?iso-8859-15?Q?MhkEnQOJFjr6Ujpa/L5T7qmrCLVMx5Fos78ykFCpSZfk3LQKbHiO8Q8zc?=
 =?iso-8859-15?Q?Wiyr91cXyXTuIDG3lf/A3Bn8vSW3se7Bsz29IRP5Ho15n1X361l4AFMm1?=
 =?iso-8859-15?Q?HbTb45dwLoOUeU/ArB2mmWlt914smoXhtRn3FCqvZsHpdf/7k1uiG5BX9?=
 =?iso-8859-15?Q?AkvQozjdkUTOKBMpXd6nxxFO22ZNiBmV9eBghB3nTOY2osBdNYfjonjJb?=
 =?iso-8859-15?Q?pRGzsplXBQ5bgpwvkhbESi9gf9sf1nYaqo2X9dAIVt3ezrtzRBdF88XfB?=
 =?iso-8859-15?Q?kdtaqZyukxK1gM+CABG69jFvpfEt3F/WBVk+ceA6KhsQeAZY3vj10ygGf?=
 =?iso-8859-15?Q?6mUk9U5+QRVE2IPI/lEvAeb5S26TU6WrXcmJoG3ac1R+ecIEUlT2DQ8RG?=
 =?iso-8859-15?Q?ud7X30aPdlZjwEGpNCLUJhnkvjMQaz7/OT7sAZU03pk9NPJWjqCjER8QW?=
 =?iso-8859-15?Q?hbkNuPGzEm/rhYb2Y1nBE9vgNrh7vcAPYUOtN8/yvVX6F5R10hrcsGtxZ?=
 =?iso-8859-15?Q?+g+L4OXupOcxvOZL7l0e7FQonZMm0Z8U3jmMHopJ7XdxKMATKV70LapA/?=
 =?iso-8859-15?Q?4sUi6qd6xa6Wr3PVQnmGekq2Q/DhXosHv8R6sCtuh3c8v+nndN3I6+m/J?=
 =?iso-8859-15?Q?XEgLx2Tm491PTHdiyPbHDlWF7ra24dNBt7rMSGQnc+bnjoaCTFqJ3YGLE?=
 =?iso-8859-15?Q?CBbDVK8TkWeK1iLyfV7U+U5hINhOKlliDEkAftyyYagkjMU9KJtv8TGkZ?=
 =?iso-8859-15?Q?v4YWfgr9pAS0BURC2+0Qp1M4NdXD45fep7kzMiBb/cJnQLU7YopU/X8Yn?=
 =?iso-8859-15?Q?w2nLpOGSA0vEXXx5K+a/MhEChRyNQq7X+iWnBXt9r4fOVgUSrJpCFR9hj?=
 =?iso-8859-15?Q?kIfvhJNWMOuwBCCzDtVsfw+t3RxwjYDBKZyaNterIL4FgmxkuSnAEJLc9?=
 =?iso-8859-15?Q?zKcfJv3L3EwrdaR3ERvH/cS5HsMzc7tgwx6RrVpX2UO+XZKM+KvIEoY90?=
 =?iso-8859-15?Q?dnj7ZdWOxPu0+jLAMFpadk1yUJGHeQxfq0WsjoY0cMd3udZyGa7hU0TpP?=
 =?iso-8859-15?Q?oXoYVXMcM7nIJXHq/bYRlO7+y4x9n4/tvEITe3pQGfzaO+fwD6AGsWFyz?=
 =?iso-8859-15?Q?OelemHyfMDylcbirscTw+v+CV2mGB4aKga5f+5L8hFV49xlC480sJyis/?=
 =?iso-8859-15?Q?HZqgunYU2u70NJoIN1C+Z8ibIiQDSj5M85vD+z3ET+adOxRAdnV8jlKrI?=
 =?iso-8859-15?Q?wiYa/if+LmWbRAjJm0hqXMregGv9L01U7UFplSiDM0NDqPLTo+9L/kDEf?=
 =?iso-8859-15?Q?fODThWpvVCEbRQa5cOVaz+1BFWm9sfmFUCukIe0Leo4x/RbjU0g224lBF?=
 =?iso-8859-15?Q?8GQgihBpWA/1gHmwESapdwEjiv3aOJvj5ZpyRe5aRkT3EcA=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <3F68DD21509B124BAB903C0B56F4582D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b7c2c2-299f-48a0-9bd3-08d9d07549f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 18:00:41.8552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R3DR/GPPuxQ9mrYkQg2EO92E7JXM7CwUpq6+i1sMA9HKIZC/uaX840PvmQUPe+7m0aFtZucAPdw87Zh5C/SHYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6555
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Ming, Sreekanth,

I'm observing a problem where mpt3sas fails to allocate the budget_map
for any SCSI device, because attempted allocation is larger than the
maximum possible. The issue is caused by the logic used in 020b0f0a3192
("scsi: core: Replace sdev->device_busy with sbitmap")=20
to calculate the bitmap size. This is observed with 5.16-rc8.

The controller at hand has properties can_queue=3D29865 and
cmd_per_lun=3D7. The way these parameters are used in scsi_alloc_sdev()->
sbitmap_init_node(), this results in an sbitmap with 29865 maps, where
only a single bit is used per map. On x86_64, this results in an
attempt to allocate 29865 * 192 =3D  5734080 bytes for the sbitmap, which
is larger than=A0 PAGE_SIZE * (1 << (MAX_ORDER - 1)), and fails.

cmd_per_lun=3D7 is an extreme case, because sbitmap_calculate_shift()
returns 0 (i.e. 1 bit per word) for this case. The problem for this
controller is the very large difference between the actual
cmd_per_lun=3D7 and the theoretical maximum
scsi_device_max_queue_depth(sdev) =3D host->can_queue =3D 29865. The
generic sbitmap logic assumes that the initial size is at least rougly
similar to the maximum.

I believe it would make sense to limit scsi_device_max_queue_depth(),
and thus the bitmap size, to BLK_MQ_MAX_DEPTH =3D 10240. But even then,
we would allocate a huge bitmap for this controller - 2MiB, of which no
more than 10kiB would ever be used (and only 7 bytes (!) in the default
case).

I'm unsure how to fix this correctly. To my understanding, the reason
that the sbitmap is split over multiple cache lines is to avoid ping-
pong between CPUs accessing the bitmap simultaneously. 29865 maps is
quite obviously too much. AFAICS it makes no sense to use more than
nr_cpu_ids separate bitmap chunks, and for a single SCSI device
probably much less (like 8 or 16 chunks) would be sufficient.
That means that we'd have to calculate the "shift" argument to
sbitmap_init_node() differently.

Here's a tentative patch that would do this, please have a look.
With this patch, the driver would use a bitmap with shift 6 for my
problem case./bitma

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 23e1c0acdeae..3e51f8183b42 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -231,7 +231,8 @@ static void scsi_unlock_floptical(struct scsi_device *s=
dev,
 static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 					   u64 lun, void *hostdata)
 {
-	unsigned int depth;
+	static const unsigned int BITMAP_CHUNKS =3D 16;
+	unsigned int depth, sb_map_chunks, sb_depth;
 	struct scsi_device *sdev;
 	struct request_queue *q;
 	int display_failure_msg =3D 1, ret;
@@ -298,17 +299,26 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
 	__scsi_init_queue(sdev->host, q);
 	WARN_ON_ONCE(!blk_get_queue(q));
=20
-	depth =3D sdev->host->cmd_per_lun ?: 1;
-
 	/*
 	 * Use .can_queue as budget map's depth because we have to
 	 * support adjusting queue depth from sysfs. Meantime use
 	 * default device queue depth to figure out sbitmap shift
 	 * since we use this queue depth most of times.
+	 * Avoid extremely small shift if cmd_per_lun is small but
+	 * greater than 3 (see sbitmap_calculate_shift()).
+	 * Assume that usually no more than BITMAP_CHUNKS
+	 * CPUs will access this bitmap simultaneously.
 	 */
+	depth =3D sdev->host->cmd_per_lun ?: 1;
+	sb_map_chunks =3D max_t(unsigned int, 1U,
+			      min_t(unsigned int, nr_cpu_ids, BITMAP_CHUNKS));
+	sb_depth =3D max_t(unsigned int,
+			 scsi_device_max_queue_depth(sdev) / sb_map_chunks,
+			 depth);
+
 	if (sbitmap_init_node(&sdev->budget_map,
 				scsi_device_max_queue_depth(sdev),
-				sbitmap_calculate_shift(depth),
+				sbitmap_calculate_shift(sb_depth),
 				GFP_KERNEL, sdev->request_queue->node,
 				false, true)) {
 		put_device(&starget->dev);

Regards,
Martin

Below is a dmesg snippet illustrating the problem.=A0
See "Current Controller Queue Depth" (=3Dcan_queue).

[ 2760.377997] mpt2sas_cm0: scatter gather: sge_in_main_msg(1), sge_per_cha=
in(9), sge_per_io(128), chains_per_io(15)
[ 2760.475225] mpt2sas_cm0: request pool(0x000000004d742465) - dma(0x447800=
000): depth(30127), frame_size(128), pool_size(3765 kB)
[ 2761.787680] mpt2sas_cm0: sense pool(0x0000000069af807c) - dma(0x44740000=
0): depth(29868), element_size(96), pool_size (2800 kB)
[ 2761.898550] mpt2sas_cm0: sense pool(0x0000000069af807c)- dma(0x447400000=
): depth(29868),element_size(96), pool_size(0 kB)
[ 2762.002396] mpt2sas_cm0: reply pool(0x000000005def89ce) - dma(0x44b40000=
0): depth(30191), frame_size(128), pool_size(3773 kB)
[ 2762.107551] mpt2sas_cm0: config page(0x00000000dc01e404) - dma(0x44d69f0=
00): size(512)
[ 2762.183235] mpt2sas_cm0: Allocated physical memory: size(66932 kB)
[ 2762.242790] mpt2sas_cm0: Current Controller Queue Depth(29865),Max Contr=
oller Queue Depth(32455)
[ 2762.326393] mpt2sas_cm0: Scatter Gather Elements per IO(128)
[ 2762.426639] mpt2sas_cm0: LSISAS2116: FWVersion(15.00.00.00), ChipRevisio=
n(0x02), BiosVersion(07.29.00.00)
[ 2762.517588] mpt2sas_cm0: Protocol=3D(Initiator,Target), Capabilities=3D(=
TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[ 2762.626129] scsi host1: Fusion MPT SAS Host
[ 2762.669095] blk-mq: reduced tag depth to 10240
[ 2762.721135] mpt2sas_cm0: sending port enable !!
[ 2762.768419] mpt2sas_cm0: hba_port entry: 00000000c01410d1, port: 255 is =
added to hba_port list
[ 2762.858130] mpt2sas_cm0: host_add: handle(0x0001), sas_addr(0x500605b002=
d80ae0), phys(16)
[ 2762.937991] mpt2sas_cm0: handle(0x11) sas_address(0x500a0b838933700c) po=
rt_type(0x4)
[ 2763.012583] mpt2sas_cm0: handle(0x14) sas_address(0x50080e51beede010) po=
rt_type(0x4)
[ 2763.086293] mpt2sas_cm0: handle(0x12) sas_address(0x500a0b83763eb00c) po=
rt_type(0x4)
[ 2763.161090] mpt2sas_cm0: handle(0x13) sas_address(0x50080e51bf1f0010) po=
rt_type(0x4)
[ 2763.243850] mpt2sas_cm0: port enable: SUCCESS
[ 2763.290141] ------------[ cut here ]------------
[ 2763.336935] WARNING: CPU: 15 PID: 9641 at mm/page_alloc.c:5344 __alloc_p=
ages+0x2a1/0x340
[ 2764.707134] CPU: 15 PID: 9641 Comm: kworker/u258:2 Tainted: G          I=
 E     5.16.0-rc8-mw #1 openSUSE Tumbleweed (unreleased) d2750100410fdc3981=
005f9733dae65153e2c621
[ 2764.707140] Hardware name: HP ProLiant DL560 Gen8, BIOS P77
05/24/2019
[ 2764.707144] Workqueue: events_unbound async_run_entry_fn
[ 2764.707153] RIP: 0010:__alloc_pages+0x2a1/0x340
[ 2764.707155] Code: 3d fb f6 a6 01 01 76 0e 48 83 b8 d0 f9 ff ff 00 0f 84 =
e2 fe ff ff 80 ce 01 e9 da fe ff ff 81 e7 00 20 00 00 0f 85 79 ff ff ff <0f=
> 0b e9 72 ff ff ff 48 89 c7 e8 30 c8 fb ff e9 91 fe ff ff 31 c0
[ 2764.707158] RSP: 0018:ffffb5dfc688fa80 EFLAGS: 00010246
[ 2764.707160] RAX: 0000000000000000 RBX: 00000000000074a9 RCX: 00000000000=
00000
[ 2764.707161] RDX: 0000000000000001 RSI: 000000000000000b RDI: 00000000000=
00000
[ 2764.707163] RBP: 000000000000000b R08: 0000000000000000 R09: 00000000000=
00000
[ 2764.707164] R10: 000000000000007f R11: 000000000000000f R12: 00000000005=
77ec0
[ 2764.707166] R13: 0000000000000cc0 R14: 00000000ffffffff R15: 00000000000=
00080
[ 2764.707167] FS:  0000000000000000(0000) GS:ffff8954ef7c0000(0000) knlGS:=
0000000000000000
[ 2764.707169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2764.707170] CR2: 00007fdb29c3ffa0 CR3: 00000002c6a10006 CR4: 00000000000=
606e0
[ 2764.707172] Call Trace:
[ 2764.707178]  <TASK>
[ 2764.707185]  kmalloc_large_node+0x3a/0xa0
[ 2764.707192]  __kmalloc_node+0x2b7/0x330
[ 2764.707195]  sbitmap_init_node+0x7d/0x1a0
[ 2764.707204]  scsi_alloc_sdev+0x25e/0x330
[ 2764.707210]  scsi_probe_and_add_lun+0x43d/0xdf0
[ 2764.707214]  __scsi_scan_target+0xf9/0x610
...
[ 2766.769381]  </TASK>
[ 2766.769382] ---[ end trace ac1aec9da4689c68 ]---
[ 2766.769387] scsi_alloc_sdev: Allocation failure during SCSI scanning, so=
me SCSI devices might not be configured

