Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5282C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 16:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbjCOQQD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 12:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbjCOQPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 12:15:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570A125953;
        Wed, 15 Mar 2023 09:14:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FFxdGP018982;
        Wed, 15 Mar 2023 16:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=GCumG9MEn6CcSUTMPqqmtCjAktclwBHut29JF7eBxAg=;
 b=xG69EDpwnwAXI0swBpTs7tkPvBQEJunXp/UjobYYaSmsP9O67wahCNLNCtkGvGOFkxfe
 QofJeSXi5RzI97WeFXuXN2A8J62PVbQFiy4v/K0zdyQFDOv/5y1Ev6Gim6fY7yL/NpJj
 /K4u9RpGeOk2nch2dnCerZH2jDYUX4YeXlbnqhdvJOLB0nCwsv97eCXkEnB2rnVi86Kp
 woeqp8gZQy6L9NTTW39I93ZGSz1vZo2Gr1uOpXoeNh+I58slI8Ce8aCDcGA1YYODpXW6
 kA1rfT5OILoH6cVX16f3auc7yiBRqLg0kP++NJlgJYFyxQVcd6X9lILbOAlENJh8DAdS 8w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2bu1rf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 16:14:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FFd47w025248;
        Wed, 15 Mar 2023 16:14:00 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2w7jw1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 16:13:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/FQM+tY/D/MZu6fmwBtHP3YDt3L0l71XWSlUklx+g4HofZtlFiG0gFNWa7yJwA8p53iBZmPJidCxe1e8z+NEfSPCpefvWNBVm/6TGT81NL9IalgW85yZ+U/1tbREu8Zxe9oB66AFapj5n3nMbr4kkiRGlVo8COVfJBlvoBwDGi/59gP4/rYljS7WmQP534k/YksZZEEMoO8gAAEKYirTOVrxlFMgirkNEOG1pGtlMAKgmLa6XBII+uhqsFpMGCKpu2T5+0s0vvgcc/iwYS2DopnHIvF3d4VYxIcQITi9sbG1J3DEbvuZEs6bGDUH/yKFZenda+53+f4OwyJSRtnaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCumG9MEn6CcSUTMPqqmtCjAktclwBHut29JF7eBxAg=;
 b=c/pjbmELezqo0Pzlp9usuE3d4gOaIh/VD1q/UhOEkz+fbv34ZNMXg7MPU7QlciReNNx+9i5UQIWVtnLjWW/nWu83MT16ZtsYr5bd8Dc+EVySHkfBY48fogAjWr6icQZhNfCU/BYVAVUpWMRBBsLJGYn6o9MHcBcCV+0y+JM4bYBU0AwCg5piTxWQckyWJEa4Qcy59DsulYPnZ/jRMzQVBAPQu7Ye/GiUn1ymj4TejGVOFKf3iZkyvmZmIi7vtWZVZpB7W9hWMkWulnBfITEiMwdxzogpUcC9qr44eMrPqRadCUVM3yB4FXlPrVHKixj8lD6WO5truNa3qD3dHSWeuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCumG9MEn6CcSUTMPqqmtCjAktclwBHut29JF7eBxAg=;
 b=b2peSKQvTo43jRaAw4m2euyEScJFEhvEpDxFdE0pKmknllFg0l4JWH0Y7ZxucFb8qEQNqxtYwTAepsdaASs8jbaKxpN3Z67LSufthQRLCmunCGgLsGgYZxkWaqZH14XAJlN+1pBvgIottfkskXDeT5uqLgffCmhpllZGxIe3dJc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 16:13:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 16:13:28 +0000
Message-ID: <7a1d3cbd-86c7-c340-d039-58d44682809a@oracle.com>
Date:   Wed, 15 Mar 2023 11:13:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3 12/12] target: add virtual remote target
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
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
References: <20230313181110.20566-1-d.bogdanov@yadro.com>
 <20230313181110.20566-13-d.bogdanov@yadro.com>
 <c004e7a8-8478-cc75-e174-5c0bbd22f4fc@oracle.com>
 <20230315075904.GC1031@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230315075904.GC1031@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:5:3af::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4662:EE_
X-MS-Office365-Filtering-Correlation-Id: 94074684-2e1f-4247-4bba-08db2570368f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVi+CL/HPK1iZSKTwCxtXpJM/46occbbBMRaHBci2tIBr/WCcJIcI1Hd5rMUXmIRnXjnUWmUfdOWKoVF0hHYgNeVcpMi6RBegI2gjA6KN17fB30QMoUW06C+868AlE+1K5YgLwpf70epZE6xcK7g/ODRfguA+s4hyZNrmuLtGLKCh2i4lkJ+TGGniCbc0c7YS4HuaJvarTMEqRTseIGVD05BVe6suPW4LYpNgQVG5o6gKUCvu/DXp5As0MpTIqUDSrt8ASYWQGQ0oV/KWnRfr1KR+lm8Uuo1x2xmhT0uMAAefKGi375zad2MAVsD8iezK2XMzE/9je/s5WZNdaXCsqf0V1ayikWjb2NFvT6m//yBgjK5GcNRn+OKaApufQSUEJZyuyXFEjdrIDW4rkW+4YvqCrwPNQmfLphnGzv4CL26MLXu8N8A4StvaLDz+smqXYqVKRyGAARLO13UFp46kJYQSxgvWZL47uUHIz/fZYnoZP7tk/ZoLl1KTdFP/k3L5Ymh1fkR35xxUGcjq1tHghHEyE1n0HsTu5edLKtJON8R7sCXStwc7bHR0cMNdFSJ8AuIButkZ4qFNNsLHfTGsegE72W9BPKvbqUD7HkIiXFQbPUK/1awH5l+vfbL1QXD/Ui+W72Ax7Kt7nJqiueWSRgIYwDGQBaeJKscD5m7OkjE9x7l6OXhvLnlJX5XKtBZDPbEZIYDwy5tjQKuzN8TxLpBg1RelOq+AVJciSc5CdA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199018)(6486002)(186003)(2906002)(54906003)(478600001)(53546011)(26005)(31686004)(2616005)(6506007)(6512007)(66899018)(86362001)(316002)(66556008)(8676002)(66946007)(41300700001)(66476007)(4326008)(6916009)(31696002)(8936002)(7416002)(36756003)(5660300002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2pKMWRsNVNicGZCaTV1V0lVcGtRZnJaSHdEOXNKMlRCTFM0QlhGVExOTW9p?=
 =?utf-8?B?ZUxqYmRzQlN5aWMvU3l6ME40ZEhPQmlVdFkzOUxoTUpCbkxtcWU1YmtYVzgv?=
 =?utf-8?B?aVFUQURiSkp5eEE0VjhEeG5QTlhYNnJXMnorMExTS0xUZXJIN0pDWTVDdG0x?=
 =?utf-8?B?Ymd4bGFYMHJiMkFLZzA0S3R6NWM1REVUc2VEbXJEUzVaSSsxTENhcXdwSDIx?=
 =?utf-8?B?ZE9MKzBxSjhjZU9DMGw2YjhnZUdpUjNDdDhDT1JJRHJFazFnVytuR3M3cjJL?=
 =?utf-8?B?eFg4ckhybnU4UlE3OEhteWtoeGVZZ1VPR0kwTUE3V09jeXFYSU1kOU1vQ09I?=
 =?utf-8?B?MlI3K0M1eWlERWEzcXlJKzA0S3VlYTA3cTVOSGdxTkZGN3NnOFZvRStZaDUw?=
 =?utf-8?B?V0VNcmpCSm15R0pzS3hndEhjWXVLVEVOd1U0N1hwN1lRUktIeU4waW5Wb1Zx?=
 =?utf-8?B?ZlFMVW1KczBUeWhqNVNBNEpFRElpUWVBL0tVMGFUZDhzU1h6emNwbTFBN0hY?=
 =?utf-8?B?VUxXSUFETFMxSE96eGJCM0ppSEhTbWpJRmZqVXJvSDNIN1MzR1RObi9aU2ZS?=
 =?utf-8?B?Wnh0WmZhR3dqeTdYTG1BUEFFUGg0MUxzOTNib1VpWkxHUzNsRnRLQmJqZGcr?=
 =?utf-8?B?RzRLM3VxMkdGQTVhUTZZdkhPeXdxWHo2T0hhdlh2TXl2NlVabHZxbTZPVy9J?=
 =?utf-8?B?K2RyRXJkVkh0dlBzMDhIVjFuVEdzbGJFdTN0Z3lqTUZVTHdrd2hHUEFvWVRp?=
 =?utf-8?B?NnVRR0p0Z2RHTm9WNEZDRHUxc1JMNFNIdTBNamtzRVVMbWkyeGtvM3o3NnRE?=
 =?utf-8?B?TngyYVl3NUdJUXF1VUcrV1Y1UG5Hc05xdXhTVWFRMkcwUS9ORzZRRWJHVFRB?=
 =?utf-8?B?RzBxMTdvQlVVK1phemxoWFBLZW1FTUlWbG1HVStCek9QQ0NyaXhXU0RJSDNC?=
 =?utf-8?B?bDhXNUh4TFpRQUlhUVIxaUFnZ1JiYUx4b3BmT3RSTWJUTHVhR1NOZTdoaGVq?=
 =?utf-8?B?TlFJYkplUElOMHNlekZKK3hRSjlIT0tJcnhySFkybld5M2xUaEwrcFNUaGtK?=
 =?utf-8?B?RG1XVVBFaUV4VS9nSzczN05ZTHN1aVQ3Q1EzaVJOWDkxTExBRW83YitISTZF?=
 =?utf-8?B?NUZKY2lWQndTbzZTQ3I0ZWhaU2J6TGV5azFpM2M2U3dabUxIdnplV2ROUVI5?=
 =?utf-8?B?a0haVnNmd25wcmRvSnpQQ0wySWgxMEV0R21YZHcwakRPa0pMTHlVMWNTSVND?=
 =?utf-8?B?dkxJOW5qM1hOWHBNb1hTb0I4RkZZcUd5YWRBUnJ2dmlicVJmVlJmNXUySng1?=
 =?utf-8?B?dTVvWnVxUURZbXJBMmNaN1FPV3c0bWM3RHdiU1lxVzg5Y0E3N05PTmFQL29u?=
 =?utf-8?B?UkRTMVQ0bTNUOWIwV3NxZHk0THNxazNiTk9MZ2owd21HelVuUnB4eUx5THdI?=
 =?utf-8?B?RGsydHBjaEZhSVNyelF5NGt4QWErUnBTYW5XY2Yrd1h0OTZMRVVEaWdubW5P?=
 =?utf-8?B?cDJjZUVrNjQ4UVp3VGMyUGovelpUWWthN244TEtsNDE2L3ArNExEa0NkRDZB?=
 =?utf-8?B?WWc0Q0hJcTZiQTB4TlNwVTQvK0pHNk1XZ1NoRWRpNTdEMTNVMGlLaHFIL2xJ?=
 =?utf-8?B?dXF3VGwyZXlPRy9oT1dmUG8wemoyZnZtdndyQXljRTZuWXBCRG9zVVlhN3FP?=
 =?utf-8?B?TEk5dEJDVW5mdCtSb2s2VFlFNEhrclVGUSsxb29PZFgyQUl4UWVWeFQrdVRV?=
 =?utf-8?B?UEdKdGJnbEFoU3BWQUdXZkFDazlKeDdYbkppTzE1VTEwNFlkdWFXQVhIYTkz?=
 =?utf-8?B?T0FPWFl3Y29NUXpoMWdVcnp3MFZhYjRVcmF0V21EMDRpSy9QZyt6RVZ1UXVv?=
 =?utf-8?B?bUg4ZGwwcVI3U083Y2tUQ1dWTVBhRVBHMFllQkJiek04VHBVL0ltRnZiZGhu?=
 =?utf-8?B?bWNubktwc0JKa01wRERtdlF1YnkwV0EwNWNBbFhZOUtEYzk1L0JhaTlsQk5V?=
 =?utf-8?B?V1Z4MXpNekpYZ2tOaE9kRzYzZTRpbk5naktVcVovdzZVemM2WkpJWHd2TVE4?=
 =?utf-8?B?aEtPY0pva3hkNDFBZlBYNGo1ek5taEJ6V0p1TnF4R09ZMEplQ1JwbnA1a0R2?=
 =?utf-8?B?QXUwZkxKWk1sdEM2b3N3WjZKbVpsN01uVWc3YktlL2s4aHBHZ28vcVNKRDN5?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dzM4SkVVMmp2Yk10QTZZUkFsMWJ5SEpjTWZJcm53UnBENHZ6Y3R5QzhTbkJ4?=
 =?utf-8?B?OFhIdTFKdERIUVk4RWVvQjY0OG5MOUZnNkdlckJSQndRdTBCVVJUTnY5NnVS?=
 =?utf-8?B?aXVoYUNSTDh1NUZGVktiaDV4bHQ4SnNmNjVPbGZBaDNNS01BVkN5VDJVU242?=
 =?utf-8?B?UXU4SXBibUVUUHdiSjdidUwweGs3VGxRMmNuZmZWTjJNdS9QWW5DSFlpSnpY?=
 =?utf-8?B?UERPSEdnSmRieHQ2bUpsR0NUVlVXLzBWTjRuVkwzQitpTVRuOEV0QXhyOEt1?=
 =?utf-8?B?Vit2V0o5MXVWbHZ5SEVhQ1BoZWZaSmU0M1R6MklEcU9PK2Q4M2hnNlhVOUdE?=
 =?utf-8?B?MTdpRW1CeURRblJVdFZtZmpaMW1xLzh6V08wZDRacmJXbVhTcmUydVExeWcx?=
 =?utf-8?B?bjFZRkQzR3hJYVAzWFRvTDlOM1lXcE84M0VPTFRBbmFya3JndExoSEpnQW05?=
 =?utf-8?B?QzNCRFF5dGtuRG9uVm0xaU9FZytvOUF5M3BjbGsvVXc5OVhrWExkMUxPUHYw?=
 =?utf-8?B?ZHFPeEJqb29JNWovTmdsdi81ZlUrUU9WL2t6TWY4NzA2aXZnYkxzU0luTWFr?=
 =?utf-8?B?WkRYZ1VLamNUdjYxb2NCMERKdEk3STJNQjErOHdwUEoxNlVreVU2TUNhbFF3?=
 =?utf-8?B?ZUtDUko2M3JPRFBUSTlreGRuRFhoVGNITkcyVEVpTG95a2d3YnJoWWhYN1ZX?=
 =?utf-8?B?VUZYSmV2dmRpSW5LNjNFVFJicWdSR1Q2c2ZKNGttYUtUL0dkZWsvNUxwZkhi?=
 =?utf-8?B?TG1oalJIMU5iYmZiWkNqdEQvKzdTNFNFZzBwblN1bTU5QkQzWTQ0eVp6RjBn?=
 =?utf-8?B?ZU9hVW52NnFoUDNncUw2THVEQTRQRUZ6NVE5S2kzS3BGcTN5WTZaVDh5VU1o?=
 =?utf-8?B?WGdFd1lQRjlja1lvemdZWW4wZWR0TnVpYkc3WTBNdy9NWStqTHA3ZG5ZeUN4?=
 =?utf-8?B?QU5rL1pZL0VCUHFXU3BMRlNlcDk4VnZWQWh5MCtKMkdHR3JUUDl6TUxISitl?=
 =?utf-8?B?eXlFRnRJMXhQTGpoaWhJc0JuK09tb2J6STF5bnVacE8zYjVxdmVwdW5NcE93?=
 =?utf-8?B?Y3pEa2ZldldoT0lBWnBtalRhYzk2OEZScWFTUUQ4a2xWSXZPczZsc09GdFkr?=
 =?utf-8?B?OEtYQm82MnJoZjVuem9VOGcvUE1xalBBMWtqNzFDdldNTkkrWXZXeHpmYXM1?=
 =?utf-8?B?NEZVaGt6REI3TGpZbFFkWS9MZ0NxZnNhNGs1bzM4c28zY003R2t0TU44SlFa?=
 =?utf-8?B?cFRzMFdLaW9tZ0RXdjRUbHRGWmpIMXNmZlhZVUdtZ3M1eWY0T01DL2V3a2U0?=
 =?utf-8?B?ODg5UGJ4QmhOS0ZGR2QvMkJaSlF2ZFVlckIyaFpXZFcrMThXQmFEVmVrZXBL?=
 =?utf-8?B?VmtIYWUxcmE3cHZkdk1LRmdzdlVCZTFTWHZSVjZqOG9EcEZtU212SjI3eUdj?=
 =?utf-8?B?YzBwUSsxSkd2MlRySEtnTlF4dWRvekNOZVBtUWVsSjc3bkdmNzBpc05BU0pu?=
 =?utf-8?Q?xVAyFc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94074684-2e1f-4247-4bba-08db2570368f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 16:13:28.7638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dmueEYv6L4yQY3O+iN0oW/iimMb2EREHeSvCE6cdPAbp7auFF7kYE1CfXkIWv3Zrk3stZ52p8cu7peuru3IclSBDFprSOmyMwr/wJwujVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150137
X-Proofpoint-ORIG-GUID: m1Q4Nzj3RFsC-2K9zZ_6xt3s-fSc35LT
X-Proofpoint-GUID: m1Q4Nzj3RFsC-2K9zZ_6xt3s-fSc35LT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 2:59 AM, Dmitry Bogdanov wrote:
> On Tue, Mar 14, 2023 at 12:09:31PM -0500, Mike Christie wrote:
>>
>> On 3/13/23 1:11 PM, Dmitry Bogdanov wrote:
>>> +
>>> +static int tcm_remote_port_link(
>>> +     struct se_portal_group *se_tpg,
>>> +     struct se_lun *lun)
>>> +{
> i> 
>> Oh no, what happened. Something probably got messed up in your patch
>> management because I saw the 0/12 patch said the coding style was
>> fixed up.
>>
>> If Martin will take a follow up patch or it's not a big deal to him,
>> I'm ok.
>>
>> Reviewed-by: Mike Christie <michael.christie@oracle.com>
>>
> 
> Mike, the code style is the same as in v2. AFAIR you said not to mix
> the first function argument in the same line with the first argument in
> the next line. In my patch there is no such mix anymore. Either all

We misunderstood each other. I was saying to use style:

static int tcm_remote_port_link(struct se_portal_group *se_tpg, struct se_lun *lun)

or

static int tcm_remote_port_link(struct se_portal_group *se_tpg,
				struct se_lun *lun)

and don't do the specific style you used above :)

I had been using the style I had written above for new code, and trying
to sync us up on one style. I thought the style you used is common in
LIO but not common in the kernel.


> arguments are inline or all arguments in the next lines.
> 

