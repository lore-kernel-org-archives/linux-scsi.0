Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554DCC6FD1F
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Mar 2023 01:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCKBFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 20:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCKBFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 20:05:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E33113D8B0;
        Fri, 10 Mar 2023 17:05:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ALi4hO009821;
        Fri, 10 Mar 2023 22:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=/rgWGTo9HTmBOYtiTiX28+NSZwv/wiqjlqyvoWUVAK4=;
 b=JcJ8WNcraIUYTVYxYKVMvcw4ZLDGcT40YV/HVm+wex0ZnImxAWvzN9uoL/DWadF1ymuY
 58W1NaS/BSOmkxht3HbVEtKVOzxXfLLcRDepMk4xIX7UWUFX/nH+hJUaAhNCbYmGJIXz
 VaYesSHS3wvBEqw/jv6M9xgHP/xDxkkaJKYFMc1a33tUiULzlvqFKvIdF2BpLU7BZx7I
 0pL0qZlAhZsF+7/yjPfUSH2kTgtMk+nOOaCmeO4oy9gTY2VB2ISJdhwDGv4oVA9Cto6f
 1+ayn9UMLEjO7fkzcFTFhyiy+3/NE+iqDoHNH/G77aDW2c6Ruwql82fEgHJT2d5n0z7k Fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn9amxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:08:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32ALuMa5025563;
        Fri, 10 Mar 2023 22:08:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g490kbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:08:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCrLWE7muuV7fkIkrnDM0F4ZGxb0ZcEQBxH3k2pte9MdMee0m7P5rMs3bQ4/ImXXV8gbftknfxHmwBmgAKOgpDFpUmjfgwiRrbAJyCUdy6CqQYAo2bpTGyrxx8BTPuaWstja08bkBg37eMBLroUBCJJRn54c7NPqLjjvby03P3V1zZzSDK3bQxNxlbN96DzaaXV4Jhi2WSfmzdI4oCqAVjqtISHhqEuLSv9gR33GpRLZfwbdaKnRM8OxI3vkkXH1SfLkRbk7F9rs/VoOvFi+JVyX85htLLR7RZjQsp/3HmlZYWjvil0zGbDsD4EAZ3Da2b0jJOmLEZmYa8wEpKbzww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/rgWGTo9HTmBOYtiTiX28+NSZwv/wiqjlqyvoWUVAK4=;
 b=DQJxDZQAO7uI/S+dYz4OrEsCfUKYq+hxa0sRfzT4I7okIkgHEHxf07qkHwJOLYFRdNm+jDVb/rxVYyGNDXtsLKfPH0DKnz0XcnVcZqQ9TAC7AuAunPSqf7unU9m1nkOS4h4mOBkV7GONHfGYy0Vd5HswQ7lSyjdLkzkrYvCfkySHfRpKF9vbvrubQIpRj0BT/GRMv+kfayeOfomB3MJTdZIBskTYxIi1cuPY/SC3lTEao0iNKHxHeu0slRTFYsyA8801q6WWSxGH1QPJ+Gj2RWqOxSrIrmo7W6V1Oo3Aa0jgREE7snzr0mp8VjMnWCWctbLpr1exQ0IPAyhVwsX7QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rgWGTo9HTmBOYtiTiX28+NSZwv/wiqjlqyvoWUVAK4=;
 b=ZaBFkxefIPJxvvRV+U4EzUkQiuefw/VLPcnjtCOzF+kKZjwnwu/+fNXvcK035o4z933PweOoCH/scwzM8Y8NuDfQR/sMeew/VldlG0EXglwGMLa8vgmMoFE/XmTBN3hbhHd+KIJUc43xh6LxaqXURphZmgGeu137BDCUc9OeFOw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB7165.namprd10.prod.outlook.com (2603:10b6:208:3fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 22:08:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 22:08:04 +0000
Message-ID: <0ae2552d-20e2-088c-224c-1fc7b92f22cf@oracle.com>
Date:   Fri, 10 Mar 2023 16:08:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 07/12] usb: gadjet: f_tcm: remove default fabric ops
 callouts
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
        linux@yadro.com
References: <20230307080742.24631-1-d.bogdanov@yadro.com>
 <20230307080742.24631-8-d.bogdanov@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230307080742.24631-8-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0163.namprd02.prod.outlook.com
 (2603:10b6:5:332::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB7165:EE_
X-MS-Office365-Filtering-Correlation-Id: f670c411-92f5-4198-02b5-08db21b3ebb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHfD45nNNbGgRI3t4nKC5utlKPhL729HG85HMqja3Hha9SSgK9iGn4ohxzG7a1fD0lrQx6y+7fZE0LI7V3RpWt9TaOA0m3/r/rlncaWkCdyo7xLd+YE18EIlBcndlA8gCXsA1FtuE3TxOvp5wO798uDWXrioQg1fMG7yT3hpctyyvV/mkT95BoLsWmbQ+ms/eM0V3Wq59WCc6exaF+vjWN0xr3ZC4sVMCVNbO5+Gh6K4j6XIbeEhthfKwlZ14JSRRBqxGpvr1vh3vAoqBXNeWQMcUtZ7y/4ybhpfvzdMvM6Ke2t5WOcmFBxUQ7fxBJ+chI+XHDLM5ftASQCoNUy4f7x1048myCXlGc/xAL+07LZ+b3Wj0DyB9DhIjQ5Qly7YhvRG1Ik4ypzcsWMqejCCCVkO/K90PZKo5enSRPpOhZlXAgtue3xPBBsad3S072+VJe6I8mgd8WeeZsf0vl9oCcB73KBJEe5HJ3pT9zlaB46X5pdZgom1sTQgDTScYB1vCMdDOF7i/zf3vysd75+3PP1hw0l2C+22wiH60n9VDBMiaSS7//Go8bxw4W9XhpYO3I5ER2iBdG+3he5oV4HFuRk2RDNywWBMW79OX+rM35q/8iJOshfis91rd4IWTgB+Ti8H14d/sw1AYhgeKMwnmCaQ6+/i2Q1CvlyYwRgCCKSlrjInZ13oF7EYM1OYEU15q+q9DNT6olF2hGxP7P7rJFHdhddTA/YDRo51rUySUc8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199018)(36756003)(186003)(6486002)(41300700001)(2616005)(26005)(4326008)(6512007)(66946007)(66556008)(2906002)(66476007)(8676002)(5660300002)(8936002)(7416002)(558084003)(110136005)(53546011)(38100700002)(86362001)(316002)(31696002)(478600001)(54906003)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K09Za3gvb1FBeTBQRzhGY1ZBMTBCY1Z5Q1E1VUV4WW1lTTRjaHF0bGRTZmFj?=
 =?utf-8?B?dllvc1lGQnlwaUU2ZVRGWVJ2bmZ3SXE0Mi9heUwyclpuRm1PNjZCWEo1QWds?=
 =?utf-8?B?Y1NrNGxlcHBHY1dMVStNcUVzdFh5Rm1xN05XY0NhMG5NdTRxSzRkMEdnanZV?=
 =?utf-8?B?Y0xyblF2cDNIRWlFWk1ta3RoaEhZTTQvRFR2a25ZVnZ1M2VTQ3BxSitxMk5R?=
 =?utf-8?B?U1hLdkYwS1c1enRlUktPREd6N09jZjlObFlEZnM0T0ZsWGc4WVdoN09Talov?=
 =?utf-8?B?VG1QalR6bWZ5bTRWQ1l2UnJEc0pBT1hZdWFQMW9LQU5SaURjc2lQVDRGRVNM?=
 =?utf-8?B?TWlPMWtiMG1YVXJQUU5zNi93a0tJTk1JeVFYT29rRk5hNkwvbStFd2F0SHZO?=
 =?utf-8?B?WXpQL3g1ek5Bem1kcllZKzlFL2ljMWNIM2h5clNjdzd0ZXZJWXE1cXVTQnpq?=
 =?utf-8?B?YXdYWGxyaU53c0ljeUcrUjUwUUs5WTF0UUJFM0hsTnBuNzJxM2ZRMUh5MHc1?=
 =?utf-8?B?a2U2bDVzMThGaWFKM1RYRHNPNkJCd0s1OC9URXB5SGQvQXkrMjVVb1Q1cVNL?=
 =?utf-8?B?RzhQb09mc3didHNvclRVcGVUTUVmbkpKaUtubk1oT21kY2pmeHlaUnpJWlhU?=
 =?utf-8?B?VmtuU2QyejJMRnRTSko4QXordWM2NXlZWXlaOGJENzVxMEF0RER0YW1qQSt5?=
 =?utf-8?B?ZEJ1M2h0SnhNcUJtOFVOaC9QcmtxZWsxaC9qbkZzNW1qZlcrc0pXVEpOUll1?=
 =?utf-8?B?Ky9VVHZONjBRQ3RuNXZya1JjYUp3TWNwaVB1MTBiMWV4ZWw5endCL1lqOWpP?=
 =?utf-8?B?R2taVzNlY1hROUxmemxSZ1Zja2FocmhxL3QxYmk2T1BmMUVYMlJiNzF4dU5F?=
 =?utf-8?B?czNsbFNKM2FVVHg1eTU5eGwwQ3N1OHBvQytMTk95QktZcmtNUDFPWHBobTB4?=
 =?utf-8?B?Z2hnU1pPZGF2THpNVTZIQ1F0anl3S3VJN205bFJnamFTKys0NU9TT2xFZ2xz?=
 =?utf-8?B?Rm5FejZrdUtoNlk0d3BGTkcwdWV2dTJYZVltYlJFTjBITDExZm96Umx2WHMx?=
 =?utf-8?B?eWU0QzQrSGQ3TlhRbjJxSVpqOXJlME1jc1hwUjdqSXdLQURiRXNzV3lxUWow?=
 =?utf-8?B?aU9ZYmlEdWp2cXY2NG5wUG9jUk5sL3prV0dhRlNJekY4VVhYTGx4RjFldzkw?=
 =?utf-8?B?Qk9ETXNVa1NnbTVXemoyemJYMUhNZW40cVA4WU1wQWhjd2VOQS84d0QySHN1?=
 =?utf-8?B?QVlhUHQ1K2wvdVp0UTZBc1lGU1ppWENVVWRMSURieHJGdjFSVlVVWTV1ZlUz?=
 =?utf-8?B?QWliS1I4TDJMVWJHRHpwWkRsQjhVR2h2Qlp4WGk5b2FnbzE1eVF3VldSOGhQ?=
 =?utf-8?B?cm9CN2c3dzd1dEpVc2RZdTZ1WWdjN1BHWnFUY21icG5YaFBXMWI3WHQyQUN3?=
 =?utf-8?B?cHppYUh0Nm9KZ2lyRjgvVEJ5ZWZhbm4zRERESUtqdFJTTmtVQmxndENBRzZM?=
 =?utf-8?B?RmdRd3ZTd2Q1dlQ0dmlZT1FGenFHZFdaRDY3V1FWbUFuTE42Sm5hMWFEVFQ0?=
 =?utf-8?B?cHhtU29VVVRHUVRadllZMWtnZlBVL3JXRGd2ZTUvNGlXbWUrZjV2SnZjOUtz?=
 =?utf-8?B?ODBkcDBibU9WbzgvQkEwRUJ1NHk0a1V0M3IrTGlyTldCMmhFa21CZ0REZU1G?=
 =?utf-8?B?OHg1aTV5ZEU2bEJnZWZWUlhTbFlGelkwcDcydFVRZERWYmNoYzhPY1kya29s?=
 =?utf-8?B?ZEtuaXpRTGUzUDhDTVBTK3RNc0FuL1JCdmswQmVTWVdWdytKdXl0OElzcnh3?=
 =?utf-8?B?bDZLRmV1NGMySGI1dlRmaTVzbmd5NXJWc3UzclZYR2dKL2UwekM2eEFPcUo3?=
 =?utf-8?B?Z1l4THp4L2ZOZVIvWVBncTFnZ0gzSWl6ODR1UDhEY292bERDWC9LMFkwMjFK?=
 =?utf-8?B?cDc5bVZVcUZHY21zYkF6MnM2YnlBS2tieC8vcmFnWFc1YXFoUE1Bc2pHRVZ1?=
 =?utf-8?B?OUtuTkJEa3lvUTBLWW5KOGxHVVBITDBTcTlNVzkxbmtYWFRIa1J3Y3ZvT3dq?=
 =?utf-8?B?U2FrVUpMZjJKNjFpQkp1aHFSaFFINUJJZngvbFVWa1RzeUV3c0dBY0VRYkRH?=
 =?utf-8?B?SENFYlJ5NDNzdzBpWmFGaWIwOERDamFzQmZWL0pSbitHYnoyRTl4WFNvNldO?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?d1p2NFNnQmgxdHRjenEwNzV1aktvQVZUMFFIaU40S0pUK1BNeUhrd1pEQVNS?=
 =?utf-8?B?RGt3Mm1MTWk2c0t4MmFpeEN6SjhnRU5yaU1GUTF0U2xRbnZJVUlsNmNhQU13?=
 =?utf-8?B?Qkpoam9UWUIwWEM3UWk3OTh4YlE2Ukt2M3RZYUhoNnlJVjZGL2s4aFNtL0hY?=
 =?utf-8?B?c2lCSXRnd1BwamN0aWFCcS96ejByRVV5NzZKWU03TXZ0SW1RUGVEaGxiOUJq?=
 =?utf-8?B?VG5UNEhOQ0FUS2ttOE8wY3NKZEQ0eG1ITDhabjJwVmRmeGZLM3V0MU9DUjYw?=
 =?utf-8?B?Y3VrYWRYNVpKVGdvSGVoYUdXcTZkRGV0U1VVNTkxdll2cUNGbHRyK3NYaTZR?=
 =?utf-8?B?WWJoTk9FaVBCQ1Rxdll3ZjBqQ1R1ditTTS9udDhqeWdnSDh0WU04WEdSZkJj?=
 =?utf-8?B?aEVrVHJaUjNyeXBXRUJwbWpNZkNqbGVGR2loNnRhRHhpam1RNHVyYnErYmpD?=
 =?utf-8?B?akpqai9HMmZVQkJURU0rTy9BV0xpMm9zWm1icWtEbXZSVm1ib2lEc3FKaFl1?=
 =?utf-8?B?c015d3E2TmZVZlJSek54UWdkd3hTNW94NDhzRHhIRU1UczdKRFg0S1NwS0VW?=
 =?utf-8?B?UTVmeDdpLzRsNWR0SnVyNDlFRjZQTkpLWnRyaUhFbjBHUCtkSFNqVk03WjF2?=
 =?utf-8?B?NUo0aGpraGdIV1JPNGsvSkFGZHAxdFpvTDRKdVVGdTJLTHYzMmRUOHRYRDRI?=
 =?utf-8?B?UlF3TTN3dHZMRmpvdWQrcnNsdXArQTRaYTRNd0trUFBDS2NCRzF4RTlEb3pr?=
 =?utf-8?B?K0RvYXdRWDRHZERqUEVYMGxkOXZzMzQrUUNVc3FxSGd1RGp5cXNEb1lNMEJQ?=
 =?utf-8?B?cFhlQ0x2SjkybittR0o5eDNrQ3I4ZEoxRVRlYmdvbVZpSmdPa0E3TjFHeVFI?=
 =?utf-8?B?VUhQK0E5d2dCSmxiU2o3d2NnTmZxcSsrcXZzVWFZRFRmTENYb3pSSzZqeExX?=
 =?utf-8?B?cjRGWk1NVm9qNHpnVXRIaUs4M292KzdOekdPZ0FQWkdNaWNWQUhMNTI3eUJQ?=
 =?utf-8?B?UkhhZ1VBMGw2dEF1RE1GNzVzdkQ3Rm9oZ1NSclFGRkdOM0tITStVcHdsdmVV?=
 =?utf-8?B?eVRKQ0hKbnpuVDBOSHd2YnhhZkMwNVAva1FKemtRN0hqZldUdUdNMC9CWVhB?=
 =?utf-8?B?VnRPWVRCdmtrUWRBRmFXZll1Q0w4RUNaWGFFeFZHOUY3WjU3aSs2NHBUOWQx?=
 =?utf-8?B?bzVnR0pWVVI3WngwVS9MUnZJRzJ2QUNLalUyTUZoaGU0Q2xjL0Y0bHB1S2FZ?=
 =?utf-8?B?YktZa2M3S1ZlakJ3bHgwY29ZT1JoaEhlcTYzUjNRenVGa0E2ZGFJTTFFbzMy?=
 =?utf-8?B?c3F0dURvcWlhUkhvSElIMmxZUFV0bnhJT0ZHMGlkTW5QRmhGYllWTmxWQWsz?=
 =?utf-8?B?a0VNWVFYeVJwRTd5OHMyQzVKeEZxaFlQZUFGdFlhc0RnUVUyNHNKRWExT0Qw?=
 =?utf-8?B?WkR3a2c5L0JlbGU0NFU2RHlIWFR6aEVqN0RlU3FXdkluQW9Qdndaa2dMUHVn?=
 =?utf-8?Q?BVaCUs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f670c411-92f5-4198-02b5-08db21b3ebb0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 22:08:04.1819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AcJoRPcnsjFGLsrKbJxsH/HKV/7+/VfI9r9aF87wusC6XRtj3/1PTY5yrJ2ssXM1nvOmmVeSlbPIGnvm86nEMHRoRSeYYJ7hI6L9ob304kQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7165
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_10,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100176
X-Proofpoint-GUID: lsiYLKEXHwH0vW8b7p0hZe1w8KuN-tZq
X-Proofpoint-ORIG-GUID: lsiYLKEXHwH0vW8b7p0hZe1w8KuN-tZq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/23 2:07 AM, Dmitry Bogdanov wrote:
> Remove callouts that have the implementation like a
> default implementation in TCM Core.
> 

The subject should be gadget instead of gadjet.
