Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA05C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 18:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbiHLSM2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 14:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238844AbiHLSM0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 14:12:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A87B2D96;
        Fri, 12 Aug 2022 11:12:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27CHOFU3020258;
        Fri, 12 Aug 2022 18:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=s8q9y4cjjGK5TPrtBa4FSRkdeth85dE5oCDrcvsXNQE=;
 b=roKVXuG9Zol9tQIwi9gZa0/xXA+YPXWSsBYkn3uVPjX7r0mJH7Rcscp6OkBvn6TZGulU
 390HRuNNmtjiLwTTEPVeJ7fcEZrExYILEIfJqJV85QRuHPGImPelvPLU45/Xu3IAc5mr
 GNAxTlOHv962J6Ej5A9VJ6gQhncd4IJKaP11jUiLxgBQivCoSyFfF15m7FpDHajG055d
 qGVAbcAsVJ/Gwk+iATMyUOYjFUK2H9uYmPftZXzXyR8W84ZU2c0DY5BnK5k31zKFqYJc
 cHm7mrb/5VfVyJHv8KUOCioc/Bhzl1SnEyGy/uKd39gaTfu3DAqS3BrSrFhXVPlDmqaM rA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbr8vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 18:12:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27CHnvVB004019;
        Fri, 12 Aug 2022 18:12:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hwf03j7pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 18:12:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwVQV1xoNE1Q0hhPM0H5Cefog2tyyLLnBSzTNqaWH9ksbeT3ZxVWWlTtuKVVRr2DvHGVJ472fWujZmOZTIpeUdLxy97emEPfjw2oLP9n/oi7Yaj1lb8qwPwYWUhg/0bUvP3sYiMJ8dqIQmM9Gbhq4IZbFiOvr+5L3QkR3/BjEITXHZ6SLn01zpB/tbjROZpBwhXtOGzADtAcCWJ538NdGSGQGxhxPYiEHcq7prb6UkvD8KU4qflf6e8l/TSnTO9OQ61sbxh5vzwCc/0iJkb8HC0SqXDk2UpPrB0uJsqnuT6TIjE/vKhDsJultuytkuSH//Napye/sAW6JmNaPezSQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8q9y4cjjGK5TPrtBa4FSRkdeth85dE5oCDrcvsXNQE=;
 b=J2LhXs/D/CzSMpknGcDX2KsiXqfkfzjYy8xTQMaoElGSTJewhJE179I3HzeCEMBMcHvRES4kiK6j+fodrcd3jtCm812QZkJ4oGyMaxEybdkE70FCuGV+PyAcfwI+WTa7TBOQAriFNlTQKNyrjtVaz7kyR0JCOoiTAIT2lvIGGfI6KSn6RzNFxZ2FJqhM7CFFtZ5g1GDgT9psp/2Qxj7FWywnmts6fALL00y55KdEkBnGcuksutXIdlcnZRcFzEqmUh6vVKm05T5uL2UIiHjW5vpD8CqEMood4nNFHiSRswH0kExcTJwG81r8imv8vvkYHKX/7z69Coh7+D3IR+sSew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8q9y4cjjGK5TPrtBa4FSRkdeth85dE5oCDrcvsXNQE=;
 b=SehHzJlQEbHNJpn4cR68/uyoRPJJE5swPhz+p/bG39ZcRdIn78X0Wrx7zmnglgAOqawCojNfJazSOM+g4uqZRBBVXK1j+u6+DojvG/cnK2VMM69di48j7vjvrJFm/HWMoFb8pE0o0hf3bNwUkchXnbGpidQScmYY7B2EVRDshxc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3580.namprd10.prod.outlook.com (2603:10b6:5:156::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.17; Fri, 12 Aug 2022 18:12:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.025; Fri, 12 Aug 2022
 18:12:14 +0000
Message-ID: <7a21db22-5729-70d2-4f3b-f5f01a98cf77@oracle.com>
Date:   Fri, 12 Aug 2022 13:12:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH 4/6] scsi: target: core: add emulate_rsoc attribute
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-5-d.bogdanov@yadro.com>
 <479fd36d-7084-f37b-a2ab-f82105278cad@oracle.com>
 <20220812113441.GB32459@yadro.com>
From:   michael.christie@oracle.com
In-Reply-To: <20220812113441.GB32459@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR12CA0010.namprd12.prod.outlook.com
 (2603:10b6:610:57::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49d2eab0-e24d-4fd2-5d11-08da7c8e2f42
X-MS-TrafficTypeDiagnostic: DM6PR10MB3580:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTtH2RAuv6C6ofFTNn5hRDi+KzeHKgLZbSq6WZ+SSpp4qpNjWJTLQg9lnN/JQhXwmk4LFRqwz9JZzwaUa+GV5iiqz+QzffSBl5OC2bR2yPZ22kb4mUfucsRyLmqzxwprfcNiEPt+NP4lmeHpUkfDNtzZ3r4KcwI0DA1Glq1pMZVorl+nAK1Zjkeo6/FHhKKQJ0PIY7SMcrJFDiZ7No8YHm1YA4j3nG4Jya869IHLYVgRxrchqvRaC+btAAVicj9CFSIE94t2nqHx54rjKVJoUgU/HAeDfmLvPU+bQiYEswUYZ0xmhzOORF9M1zk6jjiJ0eich44p5mlAuv+pG7xEl+uBdWOmSk11bjE6czMW5Znxx+N3OGAGl6bltWKmrsnddmqzZEdBQ4gouGwFupJBsEmjvpDnf18icnx54vA1hSbK1Bl0GMjZahWyLFYj9hq07gPGB/cacek0Urii86qxCaTlwQppFDnbrHQwVjjYI1KwYz0OBn2PaCCcsKt9YGGR5qn4ydfKGTDKkOjBvarYymXXOoAOVhLDUt9oL/cDCljfEVz6z63BAF1IWIUj+WCIVibhoM06sFt3HkfWmCp8X2fW5lWxQw+lwP+m7WTEpwr+DoaSXYzUD2ILmcZmy/zZd4e9R1Vlc9D2KSTVJd81XxsYU8PzrDlhfGqn0QaYUV5dGr/3n+7rs9bedBugDHWh+0E6vl7Z3z2/YkBGdSlN/CUYaM4isCDKtJ0qAejNEm+P+7NT5IyzG6nSog4DLsLrv6RQPj3T3jjO7d11RbvBDNTJcXd70KI8PWMNdDTMFsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(346002)(376002)(136003)(2906002)(8936002)(5660300002)(4744005)(31696002)(186003)(6506007)(9686003)(6512007)(53546011)(2616005)(478600001)(26005)(41300700001)(86362001)(31686004)(54906003)(36756003)(38100700002)(66556008)(4326008)(8676002)(66946007)(66476007)(6486002)(316002)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anpIa1hPSkU4RzZ3REFJTFRqSXFYMzF3b3RWKzV2a3VtR1Q1TWlPVExNNWV0?=
 =?utf-8?B?RlFtcER3VWdJR201UU4vV1owR0ZmOEtHanNES0x6NkJ3R0dUOVArWkdPOENx?=
 =?utf-8?B?c3lHTy8zZmpnbUNhUDRYMDNMWWROcjBaQTdLSkNnMWpuOFZLdkpBOWlGeEVS?=
 =?utf-8?B?R0ZGS05UY1VRVHE4b1VOMnVTWENpL0RMU3Q1ekNESzF4VjYxT0k4eFJPSVJP?=
 =?utf-8?B?TFBlajZZSlUzbmIrSm5qc1B4Y25NbWU4eDg5TG9Fbkg0STNoME1MSVBPd01M?=
 =?utf-8?B?VXIwYmdWMzVhSjJTVkVYWmZrSHFieTg5S1BSMUc0V2taTS9KaVpTeFJwbWVw?=
 =?utf-8?B?SlYrSUREN2w0WjdHL2hSUk45VEw3QVhaRHF0WDRHMnpyTU5NUVY3cVNKamp1?=
 =?utf-8?B?Nkp2d3RtS05JNkFWVmw5b1hMeUhpRWhhSWJJWkFXMlk1ZmpmZlYzSUU4czN0?=
 =?utf-8?B?M2o2TWVuMU1GamJmTkVkZWtvaEVCbXdzdUhjeEw0dlVUMWFDZWNpWVNFamxB?=
 =?utf-8?B?dmxXVVZSUTVxNTI0dURzVUdlQk03U210N0E4aE1oU2JzaERTNjVCUXBlSElj?=
 =?utf-8?B?TmVmN0Q4L2xFMXU3Q2VlOGdpTWliVzRLY1M3by9QbHo5NTBvL1JZd2gwQk9y?=
 =?utf-8?B?U01IYkY1ZG4zbzhZUG1EdjRrOVVkUzQ0d2xqdjBMR00wSGEwY2g4eUU3bGlp?=
 =?utf-8?B?RlVUQ0ZwYi9TTlVpSTVzc0JJNVIyNi9zOFIvQldEaGpBUWZBWndkVkQyUmht?=
 =?utf-8?B?OFRuZldXdEVXK1c1TExoSDdEZFY4S1NVdXVaZ3FCSU5yTUcwOUtLZnhMS1hV?=
 =?utf-8?B?dHFyVFNJa2R6dHRuKzNnbFVoOFZiS09KU2d5V1hXT2JDTzEwbHFRRlFzTVRE?=
 =?utf-8?B?eHB2UWh6SmZob1pVbkl2ZENycS84ZXhUWWh1N1pFOGMzc01uSnUzZWtpQmxR?=
 =?utf-8?B?YTVuUSt3Y0hqck4wYmdHYlhjeExtK3IxUnZqR2dTNEJZeHlGeXpIY1JDSEdr?=
 =?utf-8?B?L3RRSE15d0ordUN5YXErTkFJQmRXalNkc1BoNEZ5WE1WQjFuanR4UlA4dEVl?=
 =?utf-8?B?M3gxWkVEWjk5UXBGQU10NkQrQTJSdS9aTFBZdGpLb2F4clVNdTlBM3B1d2Zp?=
 =?utf-8?B?eHJGd3hIYlptODhjejlCQTZWWFlvVDVNenhOM3hNOHA1RVdJdXllK2c2RlNz?=
 =?utf-8?B?VkRtNWo0bnJSTmVSQndaelRGVS9CaCtHSE5SQzNYYTF6S05DSjZ2eThkSy90?=
 =?utf-8?B?ek1hYjN0MktoSlF0Q2lIbUp3Z1BsaUREUksxR29CZkErZ0p4S3lpRlc4aVpt?=
 =?utf-8?B?UjBYSWVQK2NnemZSU3E4TXpnblZEcGhEbjlpN1hCRzNGeTZvcTBDYlBJa2RW?=
 =?utf-8?B?QjZsM3BWUEhIdHJ1dkRTVTQ5U3A4RlhjL0txRE1mQjZIemJFTm1Gb0lvTnAz?=
 =?utf-8?B?QVRYYjYrMXJYUUNzVFdsRFFwbFhLcFNhUlByY3h4TkJWVm9BWTFCazZYakxr?=
 =?utf-8?B?RFMwYkhReFkwbTA1dmc2ZzIzY0Zqd095SnFzWmRYVHVkYWFvQUZJUkp6UU5i?=
 =?utf-8?B?WGxCaklZOG1lblVsRWxVbTM0eGdBWGFLMG56OEZQVjhUMHRTVCtnQlR4ZGd5?=
 =?utf-8?B?RWpoeFNvOE5sTUVMRk16ZVVRVzE1dFdnVndteU1vUmlWTlBiTXAvaDNiUFJz?=
 =?utf-8?B?RmdSTSt1YXZ5NWR3WXJ5RG5zN3lZOFZaQWZXakJQbWNtTE1LVFFKZnIyNzRJ?=
 =?utf-8?B?S2Jjc3ZHRFdZeE5ieDRQamh3UmJDYkFpZE56dU90engzTjh4Rk9qZ0RiaWI5?=
 =?utf-8?B?dldSS2V0K3NLRDE1VnhZTjdWTHJlbTEwM2dRalpSNFN2Ym9iTFA3VklkRCtz?=
 =?utf-8?B?NGdYRG5KQ0kvdW43S2Y2Zzk1cXdZbWo0a3hHWnQ4akZpVXB3Y2pRV01qVnI0?=
 =?utf-8?B?SzZiT213bm9XUlRLS2s4a21zNjI5MGRaYmVoQzNIZ3h4SHFzaHFDNWpYZVE1?=
 =?utf-8?B?RnpoTjV6b1FMZ3c3YmZXUFloUGFNRDJpZVV2R0p4MjZFTUpncHBvU3ltaStI?=
 =?utf-8?B?cnpTelgwVTNWcWxFN3Izb3UvcmdtSVJpN3ZuNHk5VENjNFRUVDhDNm90VWEy?=
 =?utf-8?B?YjFGdFhWU1lIRUJkcW9obnZFcFNMRzJXaHVPUmlweHljL21jbHNqQ3VHTkJP?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UFUyTU1BUXlpRkl5VFVIdG1Rd2dxcVAwNXdkTHk0LzM2c0dDTXdXb0VlUFNJ?=
 =?utf-8?B?Y0xwWGpNMTlRUlpQb0NjQ1F5ckFVczBKTldYOXlNU1UreE1QcWhNUktIWk5M?=
 =?utf-8?B?ekViZmg1SHdvL1FUZEF6cGFiOEw4NmdZRFZQZ0d1ZUFFTGNrLzBtSUdXUU95?=
 =?utf-8?B?bVZNZjhKZlNZYU5pU3dxUmJOWW9DQ1dESGtFNGRMbG1pbmFRSE1ZdW1wUWRQ?=
 =?utf-8?B?cnZPdngwVlVjZGh0NkxHRTlwZkh4RklMalVyZlIvUWVha3hGc3JLNEpnak5t?=
 =?utf-8?B?T0pqbnl0RjY5OThQLy90Q3pFVHk1NGt5ZnpQeDdrM2hGV3dzVEVkd3k0enls?=
 =?utf-8?B?Vis3d0ttMUJNaFYvYk41bG81N2JyVGwyUEFRUTFkN2N2Y0FJWlB1M2lsWThZ?=
 =?utf-8?B?UEtLRDZWMG0xR3RnbWVpbmJTZzZRS3QrV1Bjck1VU0FMWHo3cXd6ZnA3VElR?=
 =?utf-8?B?eC9NZUFVT1BHVXlTSHMrNzdkV2EvMG5rNURyQXpualBPSmZwOTJEVTNsZ3Zs?=
 =?utf-8?B?TERHeGMrYXRNMVc0dkhZNlltQWdHQVlDTklEOUx2OTc5em12Nmd4WmpPMXFH?=
 =?utf-8?B?U0h0OWVPdTRJRm9VcSthSUE3bExFT3pXU2hlYzhCc3FmU3prUkQ0TXpNNDFk?=
 =?utf-8?B?c3oycTJzMHhXZ042Mm05MWtjOXkvWi9tNEtvN3pHcksyMjZQR0xlc0lWUFZ4?=
 =?utf-8?B?T2hyRzFVVHV4Umc0eGFRS2Q5dXdDV0IxblBiUWdURFZNNUR6QWtWWnZ5eDA1?=
 =?utf-8?B?WThPN3dZMGFHaFFQMW9YSlhlRzJIUlRjRmVIbERlY1hVeHpBWXRhZXdIdUVC?=
 =?utf-8?B?eXlLWHdOWk9NWTM3UjFmeUF3RUluanc1OVJDeFpHQ1hoMGVCZEpTTlBINU95?=
 =?utf-8?B?Z3dNY1JDVnlsOHpWRFB4YSs5dXFLM2F3bUE1ZERSUFFaUEdXckwrUW43MjdY?=
 =?utf-8?B?ajZvdHlCZllzMmx6Qm9GakJ3bzFLV2dNWmoyWGJEczM1Z2ttNXVHS015ZkNy?=
 =?utf-8?B?K2tDc3VQaE5sSHhoLytWNGVNOFNVTTlWR0tzUXBCVkN4NVh4V3ZjcHhWanRp?=
 =?utf-8?B?N2xKeVMvb1BMaFlEV0h1azJkVnVkU3RLdmYySlNxREhjbDZqaUtTeG5YV3pv?=
 =?utf-8?B?ZXg1RGNNSHptOUVlSCt0V05maU5MVDZocWdPSVBMTHk0SUhSR1dmcFZ6Qkwv?=
 =?utf-8?B?M1lBbWZ5T1BqeElMajgzKzFjQVFnSGlwWHU2K3lyNDRKTWFOVGdQUVFzUFhn?=
 =?utf-8?B?QWNqaUgvdW8xcVRQbTNDWXYzM0MvVE14M2dFR0kvb1AzUzZWUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d2eab0-e24d-4fd2-5d11-08da7c8e2f42
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 18:12:14.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TU82B4JwhLTlajWVSPidsXAKTrL3gkORuQD7Gk8YC9fFP2NjFkBPo9dzhzx3mipTWKH/WNU5K+6W4zAQDXU9oeNvg+X6vaPDCB2fwKgIuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_10,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=827 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120047
X-Proofpoint-GUID: VWNdZIAb1vRjT8xhmAGcyqy-WWQa5_CU
X-Proofpoint-ORIG-GUID: VWNdZIAb1vRjT8xhmAGcyqy-WWQa5_CU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/22 6:34 AM, Dmitry Bogdanov wrote:
> On Thu, Aug 11, 2022 at 10:43:24PM -0500, Mike Christie wrote:
>> «Внимание! Данное письмо от внешнего адресата!»
>>
>> On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
>>> Make support of RSOC turned off by emulate_rsoc attibute.
>>>
>>
>> What was the reason for this?
> Looks like, it was by analogue to other emulate_* attibutes. But
> actually RSOC itself is independent to a backstore device, so better to
> drop this patch :)

I was actually ok with it in general. It seemed nice for testing.

I was asking because I thought you hit some regressions when it was
on and just wanted you add that info to the git commit.
