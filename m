Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD63C6FA99
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Mar 2023 01:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCKBIP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 20:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCKBIM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 20:08:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0F21ABEF;
        Fri, 10 Mar 2023 17:08:11 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ALiQjV012084;
        Fri, 10 Mar 2023 22:32:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LHRNkZ2Agyd9IaYHYvCeDcmQdC6M0NGSlvbtRdBqP4I=;
 b=kXNxqIG7Blq/Ar70CLCpdvOTsJQlV936ya1vk01BCRe0P4lw7DNX66LsHdDXDqlYrX1m
 1+g4MqTIp6UqOvioDq5TBtRvnms+Xq4K5FYj28F1WtfzrxGDqgzIBrV0b/00klLM89XK
 eghCX5acVZjxysPwwqnM0OGPoHlwVTKu1r11+2mm/RGuD+9sSdkTtC2kPhbE9n7ni4M1
 IxSuKeC2wSiNe5CS7smu65Sux/T1fdyHXf2RalIibdyWD5UMVM8R/xrpKVhBcbp15B/k
 Nom5lU61ZP4nH57vkv3qivUe4WF7OM54rbGqJ31rtg2MuU+vYQkjLd9C546toUwkEAp+ VA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416267e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:32:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32AM1dPK025054;
        Fri, 10 Mar 2023 22:32:43 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6frcap2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:32:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPPaGzeXWRI7c3JgDAXFrBiRcuw9nB3R+dsfcRhP4D7BHubIebr53kzep7PMZmY10dT3trlZ2cqr0B6Z9wExXgjzv0Mj9eaE3hQFqPQmoE5lLIL8apjoizaP8WzQoFbF/eNAlmR120WJxd25fJvHReza5CpUvGU2hMu+Emk6QeEUCL8j+8DWg2ju74mpYcl/dAF1z5jpPkjIzg1dMwiVUagzMyJSpti2iUq9K6/+TC1XzmWcqa1zkvKvY+FBc6uJ4eEltpEgaieenxo+Lt30nGVA9DitiOcwvnlFJX4Ogr7E02q/SH5dw+5WcAkd3lIifezvZCYhkzvL5SsYHSyTFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHRNkZ2Agyd9IaYHYvCeDcmQdC6M0NGSlvbtRdBqP4I=;
 b=LrbJWICNy+72c/tk/Yw7pmjWggfeIpZkOs0VidOOoMxdSymWdg1QllEOp6PeoRew+FxiNn9Kn7huD7zNfugdQmQl3R5HbRca8dAsjU+uebFdyGTMbvvwOLzDIoY9h/aLHUMPgW+3GS+4Wj7r3vpsJwfVjC44oMs3mkrJjwekfimyJIefDAlhJGHESnjM91Qyc8aLiwg/wV/vwHe+GXkXeImIvI9MjLHhD8islnDH0+WQlx0OMPCx3FbYPlH/JvNp22Khqv6S3DnylVbsQ35u7qgAd4aOKFBjevuZAB3plycAdVe1QQqvqUIKJ7imx/mxqgzqSrXxka2ro8uGKB8wZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHRNkZ2Agyd9IaYHYvCeDcmQdC6M0NGSlvbtRdBqP4I=;
 b=eKJk63gfVtDuE7v4Im9ZwfuraQNCUFPCBMftN4QgvlRoP5H6nzI+HCYcNCmdt2UTPnqwtvtwtsrEUhh5ZuBDlDsTkt+NVviYS2nYSAyuG1vCzIlf6FWEvHMW0/bJLIJLIgEVa/i8/GfWrfv5DnjGTAAgu3h+p/CYWlos8d/cm1A=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by SA2PR10MB4491.namprd10.prod.outlook.com (2603:10b6:806:f8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 22:32:35 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::dddb:e861:6afe:915b]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::dddb:e861:6afe:915b%12]) with mapi id 15.20.6178.020; Fri, 10 Mar
 2023 22:32:35 +0000
Message-ID: <f1f56999-931a-ebed-6458-89ff45573e59@oracle.com>
Date:   Fri, 10 Mar 2023 16:32:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 12/12] target: add virtual remote target
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, linux-scsi@vger.kernel.org,
        linux@yadro.com, Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20230307080742.24631-1-d.bogdanov@yadro.com>
 <20230307080742.24631-13-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230307080742.24631-13-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:5:337::8) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|SA2PR10MB4491:EE_
X-MS-Office365-Filtering-Correlation-Id: 347aba8f-3dbb-4671-4204-08db21b7585f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ORpTjW7QmtDZ3Nh026PzFw8Uf1HpZ9tvlpygk7VsCpHf2WDxHshMpmfPQDHwgViDH9l+7mH6bchmrD8D7Ea1uEz19RtGvfYGsWKAoNJweRypidA90bBlilO9vRnsneBu+qO7+otD3RgUt57o8iMmwZcYOA889cJvs7A9DmfM/JWnFcS0sM4X6AnvQwUx0AgRrZ6M115VFuS7YmurAvnWmtLkeDJqIDrupqlD6CxMWLA4okXGgPPmuh2rZBeURmUGkGHToWNRJJu9AUkBhxY1/LLaXDQC7y9YEJius/czpQ/gDkoQ0LluKJCisXBRz4r0eK6/qVRmNg3n470IxoJmWS6zr1LsUQY14AtP+QvZaxxj0HnomgItXa8uKVJgnH3NbkUZwYjEStK0WbuZ+qK53cviRpKWHcKyd7TtO/iu7p3x5jXHFXvw8fqdM7AYCoW6Bo7xS+aii0bvNfrnEt1ZCToZ4xF5pTJaiftQfJojKxPs3EfV52a4c65Gd57k9R1+F6yENPwl/emRPav4M9X5f9afacsrxvEKxiPrXTUH+/Bpf0scB9VLPgTEb67oe6jiUkcmVYcydfhYsk8DXK29K+khEkrtFMsk/c+Fovx9BieqKfze6IcFhWVmx7riZgxwIV6TJ6h7/EWe8a9Y67drrjIJrHCKQgzjL9AealZ2h2Rg2p6TVMrtjvaB8cr/M8UxIis6PaP9X3/XhH1U1CUtGHONsCRcNYHfgICU7zGkTYE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199018)(36756003)(316002)(110136005)(86362001)(54906003)(7416002)(8936002)(5660300002)(6486002)(186003)(66556008)(8676002)(66946007)(4326008)(66476007)(2906002)(41300700001)(31696002)(38100700002)(2616005)(6512007)(53546011)(26005)(6506007)(6666004)(83380400001)(478600001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clNDOEtoYXlISU0vWTZ5VFIzVHhRZlE3a1B0VCt4aUxOeTRUQWt4N2xnMmlV?=
 =?utf-8?B?bU5wekExVC9HZERnVmxtallSU0JHM2VZMXhLc1JzMFJWc0hTTTN4ckx2V0l5?=
 =?utf-8?B?VXFZN3ZMQUVrMDRjSy9JRS8yNjRBd1JvYTRCNzBaaDdiZ3BjZHlmOXZ1eGc0?=
 =?utf-8?B?eHh5NFNicEM1UStrNTNsV25LVzJVWXlWWC92dGNDNlJibFhxOThTYmdFMlVR?=
 =?utf-8?B?Q1pQUldGUng2WVFwQ3c2WTZJaElra0FBRDU1U2hjMTVJWHJjbXdzQUZ4MW4x?=
 =?utf-8?B?NHp4ZlFDdHNPS1U3YStEOWtWS2wyQnBCM3U0SnJESm5NdSs2ZEpnNngydUdL?=
 =?utf-8?B?T0laYU4yK3RDTStVazJ6b2ZaUHA0ODBHT1FhcVBrUkF5dWxHVy9lUVBUSVd2?=
 =?utf-8?B?QmVPSzRIUU5vTnU4cldXOE84Qy91V2xnQjZCY0JmRHZsNWwxemt6L29CeTJ1?=
 =?utf-8?B?M1ptdkd4RjdJWXF1MnBkbkwwZ2V0dGYrVjNRNm5uV3BkL0NmWFlXV1ZSekRk?=
 =?utf-8?B?Y1o3a1pXWldPdmoxcTJkcGpjWEtxY25kOVRJaVRFeHRhakN6SUhXZk5nY1F2?=
 =?utf-8?B?RXNWRGlPMCtsQzJ0dXlRL2o3eEpOQnh5djk0bE5VdjN5aUZnZVlTMHB6dUlo?=
 =?utf-8?B?d3JCNm5xdFcyTmMwN0xDM1pUYVVHWk0xeHdxQjNIdGM4cUwxdWwvMDZyd0pU?=
 =?utf-8?B?cUJMUk9abXI3bFFLRWRQVXhFZWtFcVppb05KaVlDb0U1cG9wRUUyWTliY096?=
 =?utf-8?B?b2pGWE82NHVIcG02TUx5Zm9PZlJoclZrQWZER1RoamEvWmxBM2hNOEgva2Z1?=
 =?utf-8?B?WGF2STFZSHhXajlLTnhmenhvQTg3cHVaa0pzSnhWRXRmTGU3UFlIK0RpRTh1?=
 =?utf-8?B?ZTFRWWtSMkc3Qk1VUzhJSHU5bUJ0WDlhb2lyTXBYWFMxckgvaUhTK1laak0v?=
 =?utf-8?B?LzN5WUdjamc5QWk0TUVKcUdTNGQwZEpyalRIdWRyMnZlQXdzdmtjRCtrQ1Ew?=
 =?utf-8?B?ZWpsQzFpSkdhWVd3Nkl0M2xEZEk0WjU0VjFJd1V6WXRQMi9ZRjJiK0N2VDZK?=
 =?utf-8?B?YzlYbmpPYWtxYWFvTy9tcFNjaFUrU2VDNktHUmo4cGlsNWxPMEYxVk1ZTThk?=
 =?utf-8?B?b1ZmS3dabEdDeHZuT05TTEhJSVU1SUpEV1dXekFudVRNZFZZb0xWUXhzdlFp?=
 =?utf-8?B?VmlIRGZRamVlOVVLcVhUZG5TeWUzTGM5UFBwQTB0SDdTQ0NlN3FZNENJVC84?=
 =?utf-8?B?N2Q2ME53YThwWlkrcDA0ZHduNkZpeURBZGZ5bTNSc2ZCR1JFa3l4QUtoUTY4?=
 =?utf-8?B?Kzg4QzA1aGk1K0hsYWR4UHhFY1hjcHAwcXlyQzMxOHNncmgwMitmMzVmQlo3?=
 =?utf-8?B?UWplbXVHdUpzN3hLSFF0bHRkN2ttMEVaZGpPZTFIU2huZXVlVzdRdnBlYi83?=
 =?utf-8?B?ekNqY0gvYkRXRkwydVZKWjZJNGhQYkZwZFV2cWZtQ2R1clUzTUtZRG1vMmZT?=
 =?utf-8?B?Y3VTZUdIN2dvVkhpQUIwVjJFV1Z3N0FOUjd3K0U0bGJIVWRyaHhEd1U5dGFT?=
 =?utf-8?B?MUsyUmRwVlJpWHMzU3dvbnVhbFkwQkRzbHo5LytSUkVzbXVaWXlYQW8wLzNp?=
 =?utf-8?B?WGJFNkM3bFRHTVJIdk5LdHkzZGV1QWV2NmNubC9ralNaR1NPY0xaNnREcVBH?=
 =?utf-8?B?bHNYV0lxMHRwUUxtazRPaENIMFZsVktlVmpvTjdnQ05tVnU1TDRQbU9rVFJY?=
 =?utf-8?B?aVRBWVl6aSttMk1jVWJIRjVCZzQ1VGVCYjExYWhaQzFHS29kSVplUkZobHRV?=
 =?utf-8?B?UTVMU3BMSUJoT0hyYk5hbGJpNFJvWGtxTUFWSko1Y2Q2dkFDUWhBR2dwL3ov?=
 =?utf-8?B?Y0hiMGhUaGFBc2x5SklFcUYxNkVOL3dJcHo0NHYzdFJYVVBNc2x0NDNaWTN3?=
 =?utf-8?B?K3JWZWtHYzk2d0VEaU0yUEIzdXlRdHZOcENPa1hNd2svYjhVTlpDU1IyMmFT?=
 =?utf-8?B?a2pBOWRrOVlPZEZaNER5QSt4S1B5aklXVDN6UGR3V3FIY2JsRTRXaFFZWUt1?=
 =?utf-8?B?YnJzUjAybnJIQ2dCaitKU256YXIxeXRSK1VyVko4ZjR1ejB0dnAra3RjY25p?=
 =?utf-8?B?N21QNFNVMHppbThONjMrZlRObFk1dmhhS1ZRbzZpeHRXcUVuZG5zK0pieGc5?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZEcxaGMrTHB6am5kZE1meVY1bm9MZERwWlVyN2RDTG9oTHQyWkJaTlpxWkE2?=
 =?utf-8?B?MmNwVVhkWEU2eis4R1c5Q2h6aGpqQ3VONW9WYlBHK3VwelF1bzRwZWVIdW5a?=
 =?utf-8?B?SEhFVzJLZHlLVUErK0dacXlMZkdVQ2ZRQ3JDVzNxeGtadXFvQjNZaGFpQjlx?=
 =?utf-8?B?U25KQm1qc1RVcmZ0bVBNSkxhS0xDRjNma3BuUm9VcUErN2lZTVBXWkxSMnQz?=
 =?utf-8?B?TEhYektldzJMdnBwL1FuS3d2TFF3VTNSeE4zNXhidkFvbmdCU2FHblkweHVK?=
 =?utf-8?B?dXBGY05CeEsza3c2Ym9LWTAvVjhodWVCaTA0Tm9wNjJlWlFJcGxUMkFoT0RY?=
 =?utf-8?B?WnI2N095YlRnbGhoZFE3Y3k4bHZwd1pWbXI2ejlvYlZCL1YyV2NKY3I3cUJw?=
 =?utf-8?B?NmN5QWJ4azAwbUV0V051WlUrOVV1emF4YlB5Mm9tSFpkZjE4VmpzWml5Q05G?=
 =?utf-8?B?c2NGcmluVTRMYWJKOUdMRTB4Tmx0dDNKK0VrMnBSeTdWb0Q3NWdENjJiaFRL?=
 =?utf-8?B?K0t3YmtYL3Vibk5aWkVVdnd1UmUwNzlMSjFZZUNKYllLcXJJV3dXZjF2T3VB?=
 =?utf-8?B?cXR2QXNrVFNDaEdXM21lRHlJM1RvTTUzd202TDZVY1JQYUV3MktETm41RzBj?=
 =?utf-8?B?MTQ1YnpkeXpTdDNib0dnZnllRkhBcTRaU0l4MGhPQnZHT2k3NW5DWkZQUXFu?=
 =?utf-8?B?cDBWT0o5WHZYbXQwS3dXMENucnMrQ1BBM3JJWENKcmxWNTBxV3VMOXllK3lm?=
 =?utf-8?B?REJvVE9MMFVSSXNuTS9KMXM4YXh5RzIyTG9YQmZsN1k3cHNiZGFGRjZFUmZR?=
 =?utf-8?B?Q1JXVnFvZmlLMnNjaUFRbkhhWUMwVDdZOE94V09SNGpvRlFvTWRyanN4b1Fa?=
 =?utf-8?B?cHBCUmlIdXFTN1Jud0c0SlZkVjd4eEllVWtoaVhBK0t1aERXQVRma1VmSUFu?=
 =?utf-8?B?bzA2T0hFVWRwaHAvSXZrQjI5djJnWExQUEE0R3IyKzFtcHBSWGJpUzdtS1VS?=
 =?utf-8?B?SWlYTnVaQXdTbVMvZDFnTXplQVREUFZTSDBiY0F3VzI4MVgrTjVNcG9jQXFT?=
 =?utf-8?B?WS9KbUgzd0pqK3dXRGFnMlJWaDRjSHJNWm9XOFpUWDNQT1Q3NnMrUzdGM1pj?=
 =?utf-8?B?KzF0TUZFVGZzcFZyZ3VWVWhWdTBOMThrYTV4NWg1VUZHM3RCVFFWYmt1VUpw?=
 =?utf-8?B?L1pCdThwdExlTnZCWTh0UldhSzVENVBhc21qRlpMRzFCOXZYZTVXYXh5WUUy?=
 =?utf-8?B?cm12VDBtbG9HdmxhR29MeHN2eGJDZFhVZ1F5ZHRBSG1lRkhFY1ZBVVBLZXFK?=
 =?utf-8?B?bnpaanRMd2VwR1U4bkw0RGdRd1JYZE1tTEltd2VQb3hONnV5T2Jra0l4RG03?=
 =?utf-8?B?Z3lpLzNsNmhpeHduOFFwSDFMRnROeWYxUEJFSnF0aVJsUUUvRFozYTFRZXla?=
 =?utf-8?B?clA2dERaNUd2aW5xSkRyK0UxNlVpZWpycGVDMkdzdE12RUdvZWxFZXhqRzdm?=
 =?utf-8?Q?KmLMGw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 347aba8f-3dbb-4671-4204-08db21b7585f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 22:32:35.2176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjvpweeeAKeipaH16NMMsM7sdR6bXyBMQVuxg32TyHsebIAEbjFVqmGZd418t4RWj4GKmc6DJqAxipyhleZDx9wPVQwGORfIlpbVBcqbAWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4491
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_10,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100178
X-Proofpoint-GUID: Zk-pVi9BqgtxEZGzP44KADyAn2B_yZCI
X-Proofpoint-ORIG-GUID: Zk-pVi9BqgtxEZGzP44KADyAn2B_yZCI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just some nits.

On 3/7/23 2:07 AM, Dmitry Bogdanov wrote:
> +
> +static int tcm_remote_port_link(
> +	struct se_portal_group *se_tpg,
> +	struct se_lun *lun)
> +{
> +	pr_debug("TCM_Remote_ConfigFS: Port Link LUN %lld Successful\n",
> +		  lun->unpacked_lun);

The l in lun should be one space to the left so it's under the ".
It will then match the other code and checkpatch won't complain.


> +	return 0;
> +}
> +
> +static void tcm_remote_port_unlink(
> +	struct se_portal_group *se_tpg,
> +	struct se_lun *lun)
> +{
> +	pr_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n",
> +		  lun->unpacked_lun);

Same as above.

> +}
> +
> +static struct se_portal_group *tcm_remote_make_tpg(
> +	struct se_wwn *wwn,
> +	const char *name)
> +{
> +	struct tcm_remote_hba *remote_hba = container_of(wwn,
> +			struct tcm_remote_hba, remote_hba_wwn);
> +	struct tcm_remote_tpg *remote_tpg;
> +	unsigned long tpgt;
> +	int ret;
> +
> +	if (strstr(name, "tpgt_") != name) {
> +		pr_err("Unable to locate \"tpgt_#\" directory group\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +	if (kstrtoul(name+5, 10, &tpgt))

Add spaces so it looks like: "name + 5"



> +}
> +
> +static ssize_t tcm_remote_wwn_version_show(struct config_item *item, char *page)
> +{
> +	return sprintf(page, "TCM Remote Fabric module %s\n", TCM_REMOTE_VERSION);
> +}


Do we need this? I saw other LIO drivers like iscsi, fcoe and loop have them
but they are never updated so it seems useless.

For something like stable trying to manage versions is going to be difficult
as well, so it might just be more confusing.

> +
> +static int __init tcm_remote_fabric_init(void)
> +{
> +	int ret = -ENOMEM;

You can drop the -ENOMEM since we set ret the next line.

> +
> +	ret = target_register_template(&remote_ops);
> +	if (ret)
> +		goto out;
> +
> +	return 0;
> +
> +out:
> +	return ret;
> +}
> +
