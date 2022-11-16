Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200D7C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 07:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiKPHHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 02:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbiKPHHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 02:07:13 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BAA167E6
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 23:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668582425; x=1700118425;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xftfQ/7pCvGnUHRlasHfv14YoBl68CrpMLumbbQd3Qc=;
  b=nye4XkH2EmYZxC7tpGbpyxRU4OZTCqv1gSF4xU6djHji9wwtq/uoXGaZ
   5JXiHNmkRWhTAbrkNnGXaqoE0O1rgufw7kUNmr6kP68KY7r3vAaCKj1s2
   iIh91fnWaYQTHWrpJuGKFMHUvvL87oYL8HTWbkng9VSrDn7LKkllQe033
   LC6FUaxbpkEBNcSLepESp+mvyKU/KAtLAV6s7qVrSy9nscTUx8GondjgP
   8WUaOobiTInFbHkvRdeKgDYtJ6UuuLlrNFOUXMSmYfgr/+Z3I/Z2bBvG3
   u2J/clgtB3sbHIY3SYigzmVcTzVzi+EXQG1qf2mXNbjp6W6+7HbVsZhLr
   g==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665417600"; 
   d="scan'208";a="216714736"
Received: from mail-bn8nam04lp2045.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.45])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2022 15:07:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvBegsss3zzERtV5v18zK8Po181XPI2yPAnxYeCL7QsvJYMLVosjH6e2Z1b4QCWyzEl2U4z9bujXhuZosSUtu9vlUpkafV966Q/L8JYRv9EfExcyCic6CEgFXySyk4D+5M9g58TbBkbLGkJ4rNtW4ZYMWxBSgbI6t4vG8FAIvpBjbvPOml7pr5YbrMWD9a1C6Z5kDTsPY4cQRWfacNSL/mJ7C79mzC+dZMxdjVvKq/Lkh+DeSljrnD4UctG+GaZ/xZiSGsmOx6qoeL0rPznLWu5NhadxlPLraXh2sJCblrVE7v3imBpaWzl5SJiUN9wZ+oL3PSup0je423IYDU0QtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xftfQ/7pCvGnUHRlasHfv14YoBl68CrpMLumbbQd3Qc=;
 b=mSzQ5IS+AFHuPjr74I7ULS/hSqD7SJNMN7YSxvy1UJFMvRV9HAr2osYd/tExKJu4W21W0mAGV41gFScWkTpA2ImBlG0FhybfUyiejUf26YvoiPkFWklyuaMP8CK6JdUJUmYcbsP1uAtMD0Kq3UqQldFYr4o14tP3Nl0Qi7UKaLWUFqMtOChZQ4Ar3SxBEov6LG0j0uT6HY3txq5TFFnG0FgYz6vbBoC8ZUUMvY9la9QBkEa22vTyg3VpPxe6ebUQ2zeRU/q+niFJStplF+LS5xJEm50oQ32VgqKdMt4IWGjwlz7TGEfOlcMHD2+hZRs6lZlWUusA2sOv4NdsI4pJNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xftfQ/7pCvGnUHRlasHfv14YoBl68CrpMLumbbQd3Qc=;
 b=RHYeuE+8BlBeZ53HOAkpHb6IwLeLJIZ3EwbjD96a9wd2P+UQ9RStABpw8TqZ0rDI2nLbk/b3Q4yErmiGMq0zW7QeWuDRXxz8NrXK6SQiTfPCISd8wyMUvUQuMeIHoR+E3jUU/J7Fr+03qI9e041/Jtlnod4is7W+/hET6mgM0D4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL0PR04MB5028.namprd04.prod.outlook.com (2603:10b6:208:54::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.18; Wed, 16 Nov 2022 07:06:59 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72%3]) with mapi id 15.20.5813.016; Wed, 16 Nov 2022
 07:06:59 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "hch@infradead.org" <hch@infradead.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Thread-Topic: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Thread-Index: AQHY+MamVqmOHdmxGkSI0uQCV/pSWq4/rcLwgACzyYCAAMCOAA==
Date:   Wed, 16 Nov 2022 07:06:59 +0000
Message-ID: <DM6PR04MB65758645046CD027EC5240D4FC079@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-6-bvanassche@acm.org> <Y2uechJH/4GFDs8h@infradead.org>
 <e343400f-2c87-8abf-5ebc-9c9a4a9030d4@acm.org>
 <Y3NETRqATLK2Z6LZ@infradead.org>
 <DM6PR04MB657558167A98D2E9C0D63C57FC049@DM6PR04MB6575.namprd04.prod.outlook.com>
 <254a89ff-77b6-8e1a-a31b-4f5ecbc59520@acm.org>
In-Reply-To: <254a89ff-77b6-8e1a-a31b-4f5ecbc59520@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL0PR04MB5028:EE_
x-ms-office365-filtering-correlation-id: fe8a99fc-a6a3-4b22-c884-08dac7a12788
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zbkdd0KSNAvjAgHg+I4NxmfJqiX+xVs7hR0Tno1IIrEkhpWLg/tnTu7uG7oxSOINJ1U4ZpfF4v/Bdk7v9MgZ9XtZe6j+Hw7RT+M9a2804tXDz2XhHeVh8AbE3FvEbf6GtAdmc80R1bljMEkeP5HydpsiiQ9lFY9Dmeq2ZNpdkVselhGHP/Y2De+22uwQtFfaBhCRza4aU1b9mVnGQI54Ydm3ObKP+zncs9Um0Sc1DBBwbSTq7ZHcGS7NXezNhthX+6KzhQ92HtvgWgo1gKpLy4fA9B/M+id3lVkLpMRc2+iD6NAY4qqwKjxXRUsrqZ5ZC1ReZHCahrRlRp7QKzAmxVWkiOnjke2w0ng2CDmySPolvymCqFQqwRmaZRV+zUd9AMujPumTCQQSewxO+ZIjN4b+sGwYHcoIB7vaQFMq+I5/akQOu+FymH8eVW6l1G19nQjProRPmNS1Jsa8AqAkGXo7Fe9SJK2aPFN8FoCSF5SfNEO12glI4RZbugnMbrKFtdRk/zoGvOZlw3/V9ohwx3g4owoAlcfKOorpVHuPJDruS9f3C9lfBLuXpSyYAsMizFcZ58PFyyQ/P/yUQ2HFnny0bUwd5WEZD6nLWBa8geJgXfnqBZM3A51u/PqSnp/wV2ulEIxq+4+GBuqK9FRcOuE3Vc79rKsKyIc8DqAwCi5C2goMDyTbgRi0G7lIG21lXuou8Di88gctPYfd5g/gm82fWkDpJFNQ8/Jear/BfF5HLJQ9iP84X1AmQ9y30iGRxKQ0kBz28uHfHa5bCOK8/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(8936002)(52536014)(7416002)(4744005)(66946007)(64756008)(8676002)(76116006)(66446008)(66476007)(41300700001)(86362001)(66556008)(33656002)(316002)(4326008)(5660300002)(38100700002)(186003)(82960400001)(122000001)(478600001)(110136005)(26005)(7696005)(53546011)(54906003)(6506007)(9686003)(55016003)(71200400001)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TUljMFJwNDVrMVpYTzRIdGVXb1NINTRqSmdBWmhJQi9kSFdWMGJNdyt2UlFq?=
 =?utf-8?B?QXBaajJNVWprODJlQzZ3cUxsdEtHbWY0N3NIUzJUaXlnb2h5bm5ueG8xemF4?=
 =?utf-8?B?Q2dRVTV1OU52UWZRTUJIT2thQlNQcGlkdmJsUll6a3BHMnZZeWNCcnJFVkEw?=
 =?utf-8?B?YkFyaWtKZEVGNXQxY1JxRmdnMFpKaTViV0FJaXJ4OHJtenA4b2hoTk5nMkFT?=
 =?utf-8?B?Y0pYRm5xSTBLSzZ5blkvZ0JsSU1RN0NHanBKWXBZUmNVMWpRSGZsWHZ0bU8z?=
 =?utf-8?B?S1Z4UWFjNXkwVmJVOHMzOFFLTi90WU1PL2dnL0FSdmlQQ0tUdk9pTjhueXNY?=
 =?utf-8?B?Y0ZYK29HZWJ2YnUxWCtGUVdHb2NzdFpBK21RaitrQVAxZml1Y0VLcUY4L1p1?=
 =?utf-8?B?U0FDK1QxNFphMjFlOXJRM2hoMzBnSjhZN3BMUnVMTGRUaVNDbHZMaDZTNTZB?=
 =?utf-8?B?Sk1XelpvTDZ1c2RaOTdRaUN1dTdoTEZtbEpxbzJLc2VMSG9IczlJUnZtU3Np?=
 =?utf-8?B?d3lqeVZyYi9NaS9FY3FJMnUzaUJXSVBwbWp4VDhNZkx5U3J6MHdzYUFQaDEw?=
 =?utf-8?B?aURHQ1A2QXZJb0dRN2o2RGQxaDM1T280eEhLOFZ0WmRlOVBWcnAveUdOR0ly?=
 =?utf-8?B?cHJnSXdaUEo0aWVvbFl3U0ZxRlllakZHSEltaGl2dDQ0NnNINmV5ZE9lTTlT?=
 =?utf-8?B?WkMyTVltZ2tNUmxZaU9YaTlaR1lDc3BnYUMxZmdGMit2MG1YbncycjBsY1Rl?=
 =?utf-8?B?K1E2dmNwRUV4bWIzaWF1bFczZkI5ZDNwRTdBOGlsWk0zT0NKRDNCeUMzdVMz?=
 =?utf-8?B?ciswZW95S05xU0tOVmt1VCtDNnpHVmcrYjVacEMvak9pV0llWGpFWUVLYzk2?=
 =?utf-8?B?ZnVTVDlqbnNmYkpBT1Q2VjVVVFpzSFBVaEdWNU90VkE2SkZuQm5aZVBkbGIr?=
 =?utf-8?B?QklJNDNUU3FXUERNNFhuWXdsZ1hEaEpoT2ZrL3puaDZ3ZkZhTjVibFRmeXJk?=
 =?utf-8?B?am9DaFU1M016TlJOQW1wNmhKeFNzOW0vL0VRUldVRVV2eGNVdm8vaWpKZm5k?=
 =?utf-8?B?ZnlBMUQ1eTJsZlNCYWZYa3pPU3dBUE94OCtQM1NrN0M3SEZiTSttdStuVE1F?=
 =?utf-8?B?SlhoYzRPTUZ3ZzhnSkNlUE5sTlFRS3FDVXBQcXZCVDJPd2h6NFpUWmp6c2hx?=
 =?utf-8?B?anVhMEtMZmIvbXBNU2cvTERWMEVjbm1YVmMxeXJwdnpVSzRuUVZyWDZCb09L?=
 =?utf-8?B?ZCtnVDBoeG1yWnJTUmdhSFBLWmhBL1pUV1NiNXlEQit5aWxZMzJMNFF0TGlp?=
 =?utf-8?B?OFliSEI1eGx1cTY0Z3FBbEVXSGFXRFUyMTQ1bHFGMXE0UzN3YmlIbXBveUlw?=
 =?utf-8?B?Sm1xVXhGRXYxdnRxbUdsRmphQWRjZTF1RUhsRmxTYVRna2FQUEFYVE9yMG5G?=
 =?utf-8?B?SEVLS2NwVVNMKy81VjhBY1ljK1dITXlLdm9WcDdmRnpQZkVpMkRQdGdxbFd3?=
 =?utf-8?B?ejJJeXBleWZWb0dGNGJvUmdIK2JMQzArZUNlMW5uWFVMRllrQmJDYW5HYWxj?=
 =?utf-8?B?L3pmczVUMlJzTVFiMDY0VHQzZlZPN21ENWtpeXZWM2RsSnBVVjNaUldNOEN0?=
 =?utf-8?B?OU44UDROazgwV1pyYndkMmtNaEJVV0JZdmZLTTYwamVpWXY4dFgwcEV1N3Fl?=
 =?utf-8?B?WWR0MnZkVUNxVjFaemE4dlNJN0lWYWtldzlWT3NRWEpSa05MRkxza2FGZE1K?=
 =?utf-8?B?ZDV5QnRDdnBiY0hHc0lUMFVwVkhQeDAyTUpCTTM3YW9zSnI3YjF2d00rUkZJ?=
 =?utf-8?B?b2p2akpsMUJac3pNY2tvNXBKeDFWcGsvL0F2amxYcGxxTVBXc05mRDhaTGxh?=
 =?utf-8?B?aTRiaUl1NE91dnBlbnFPR3FVV0ZSbHB5RlBYMm55TmFUdjhJVFpYcW5WUDdV?=
 =?utf-8?B?UWhHNU9QNHlLT2hmYnlOeE83R29CL1BRTzJLSzdjQlpvaXFFVCtJNjdkSDdB?=
 =?utf-8?B?TTV0aWhpYmR3TysxV2x3N1d4emp3ei9MUWhSdWF3TFZ2QkU5aFc4MWdoOHdm?=
 =?utf-8?B?b0hVUXg5Kys5dDJjZFNpOUIrZTJpeUNtYitUaXAvelJ5dmhvT2lLTzlWZmNa?=
 =?utf-8?Q?G+HHswqlE8UfuKtuezLb4R7u0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?eHNpNjFHNy9xZVVUYktXWkt1NDUvLzdjR2pPOWdJVnF0OWFMRGtjbXlyN3FY?=
 =?utf-8?B?NzJwZVVRNitWSjVTMU9hZmJxRytjc3M2WTBndkt3SDIzOUEyRFRWaTBDdDZu?=
 =?utf-8?B?THZ6bk9oc0ZxVTBMV2d1WW9CS25RQlozWXM4Mk5tZ1B3MCt5eGFWMVN4NWQx?=
 =?utf-8?B?aWpHbkt5WWRZS1RCZnk2YTVlSjJlRS9yZTZEYTJmMGJQRURET2tHMlR5WVAw?=
 =?utf-8?B?VGx2QlhneG5lMG1mMUhGQngxMHpLVXc3Z21YbkhQUloxTGRiVUxQTVJvcnBw?=
 =?utf-8?B?dG9PLzhiTk8rbW1TTVdXYXNNZm4vbml2bXhpaGd1QlRCb3hTdFNxWW9rYTlx?=
 =?utf-8?B?dFg3K1dxY0syaDlVbGhpMkZsamFMc3pSQmpKb2U1MFJkeEhZaENSaURqY244?=
 =?utf-8?B?U2xRSDV4ZkMxVi9wR09JY0ZwTXZ0dGNFYUlkRUpwVndsNWxPM1k1YUk0am9s?=
 =?utf-8?B?R1lZOCt3Nk9nMW1XQ3BvOEh4eEFmNE9Qb2dQUWxKWk04Y2lOcXNRNkNqdTQv?=
 =?utf-8?B?dVMraDVmc2t4Y3UvNzhjeWwwbTR4UTFLT0h1czY2UXZ3ZXJLSEJ4dmJ5bGx3?=
 =?utf-8?B?clUvMDhuVERSVzNrR2JhenVXeVVvQWkrY1JIbno5NmhFN05BWkpFL2tPc3dB?=
 =?utf-8?B?Tkh5TU5lZ0NXTXFJQ2ErRFYxbUk4a1c5UlpnNklaN01ycXIzYnNtZXNLdUtm?=
 =?utf-8?B?dzZQNzd1dTU5TWdQWFB2VmVEVEZBRXIrYXp4ZXBZemJBcm5uQkxtS3BPNHVy?=
 =?utf-8?B?TlZ3OHVoYWNsMlE3aElXc2pPVlhzck1pdWlkaFB6RjBPWU9sTFRLNlBGdVB3?=
 =?utf-8?B?cHVCckZoZ25Nc3MveTIyK0ZTOC9CZXB6bmdoaUdWNDZBcjlJU2xjbUdKSUl5?=
 =?utf-8?B?dXljQnpISlZGZFJBTUQ4Rjc1blBoNDgzU0FQakVZa1ZzYlV5YmloUnkvcnBh?=
 =?utf-8?B?ekFjbnNQNW1OcXBYM09YZCtIZUZyUkhucUprcUN4VU91ZmdjbWNTajgrcC9G?=
 =?utf-8?B?czhoTXlsc0NBcjJYcnB5eHFjYW01UXF5djlMaFk0dGR5NWtoTFFIUVl4NzRD?=
 =?utf-8?B?WGlueXY3RG51V0VjKzUzMmt2QUMzSGIxOElMSkZGa2JlZXYxUVhtTDY0UjN0?=
 =?utf-8?B?aWRObXE2SUNTMnVmckRZcElQUkpCV1pFVGhtZGRQM05rQng2R0p5b3lGTGxH?=
 =?utf-8?B?dEdKeUpmVU9pL05jYzJIdTV3ZVp3bncvZGc0dGxvcUZYZmxYaUF1RmhkMXJw?=
 =?utf-8?B?Q0JCWUx4WXhYZmtYZ0ZsNlB6Zmp6aVdlaGN0VGowLytoS0ZZSG1KandtakRZ?=
 =?utf-8?B?YWYzZUFzK3I1cno3ODNWNXpGdFB4N3VtVjBvOERrUFhya3pYTWl3VGh2MEt4?=
 =?utf-8?B?Qm9uWVB0VU9EQWIxNnp1WjhYTVpsYkRObmxRNW1qTFhMNno3ZXNNcFhUd3N1?=
 =?utf-8?B?aVd5QXcxYWxFR3FGK3N3Rm85SGt4bTVIQXEyZUlQY3RVblIyS1JudCtJVjVy?=
 =?utf-8?B?ZEJXMkZYQ28rK2RpelVKZXlmdjdCdGdJamt3VndqWG9TVnhsMHY5dUVWMFlT?=
 =?utf-8?B?OEJaM210S2dHaHlONkZiV1NFYS9uNi9rUGFlN3lrb1pOdXg5NEJSaVhHVWtP?=
 =?utf-8?B?Q0xyMmpBcnlvU09mN0NBVVV5UmxZRkE9PQ==?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8a99fc-a6a3-4b22-c884-08dac7a12788
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 07:06:59.2190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wQkfyhCu8dV18xs9kCMeA396wOOGKyTqHTkR77zqJX9+fsIx/Rv4BdWH232x79W7+WdcIINOm0jD7qkXD1V5wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiAxMS8xNS8yMiAwMDo1NiwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gSXQgaXMgdXN1YWxs
eSBhY2NlcHRhYmxlIHRvIHRlbXBvcmFyaWx5IHVzZSBxdWlya3Mgd2hpbGUgdGhlIGh3IGdldCBm
aXhlZC4NCj4gDQo+IFRoZSBiZWhhdmlvciBzdXBwb3J0ZWQgYnkgdGhpcyBwYXRjaCBpcyBub3Qg
YSBoYXJkd2FyZSBidWcgLSBteSB1bmRlcnN0YW5kaW5nDQo+IGlzIHRoYXQgaXQgaXMgYmVoYXZp
b3IgdGhhdCBoYXMgYmVlbiBjaG9zZW4gb24gcHVycG9zZSBieSB0aGUgRXh5bm9zIGRlc2lnbg0K
PiB0ZWFtLg0KPiANCj4gSSBjYW4gY29udmVydCB0aGlzIHBhdGNoIHN1Y2ggdGhhdCBpdCB1c2Vz
IGEgInF1aXJrIiBmbGFnIGluc3RlYWQgb2YgYSBrZXJuZWwgY29uZmlnDQo+IG9wdGlvbiB0byBl
bmFibGUgc3VwcG9ydCBmb3IgRXh5bm9zIGVuY3J5cHRpb24uIEhvd2V2ZXIsIGRvaW5nIHRoYXQg
d2lsbCBhZGQNCj4gcnVudGltZSBvdmVyaGVhZCBpbiB0aGUgaG90IHBhdGggZm9yIGFsbCBVRlMg
dmVuZG9ycywgaW5jbHVkaW5nIHRob3NlIHRoYXQgYXJlDQo+IGNvbXBsaWFudCB3aXRoIHRoZSBV
RlNIQ0kgc3BlY2lmaWNhdGlvbi4gSXMgZXZlcnlvbmUgT0sgd2l0aCB0aGlzPw0KTm8gLSBJIGd1
ZXNzIG5vdC4NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0K
