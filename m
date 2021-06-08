Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FF6C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51AA361263
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFHDH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhFHDH0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15833nAx000722;
        Tue, 8 Jun 2021 03:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Y9t5vSU8PyO1RpWtx1tKVybqONQTQnGZ4vPrqoQXO54=;
 b=SeBTJ+QvwBmvLOTcIoOAzHl9jXi/X4snoMc5meD+71xZTj6BNLiWCz/BAMU+JnoUt+Y5
 C+GOUy/KwhkYehTd4qo2FGEU1Ha+yL2hYK4QITAnAMJI6lPWULDFAZ60HQUBHqR17qAg
 vwYJ6cZI4qCXb3c21Adwgz6LQ+k89OS48QdXDbfPagDgCbwEhmJ+g2IHNdHf0svJRdCr
 2p9ITkVbQOVdhDk+FxjC0pwB1Mnz+SjomlWoldnHuXOK1yG0SXxUkaE+y7jzxR8WKqXH
 /mygIi55aRv6L4U5OQvHpPXmE7nvb9PZMoKUqo1bMXMkzHqpmFyfpKYfP1rnNQj67cUX LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 39017ncjmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834pCU084953;
        Tue, 8 Jun 2021 03:05:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3030.oracle.com with ESMTP id 38yyaahxw5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLZ3Agfyr0Av8RfMEr/Ncg1QlfOqkmY4T0X+8dM4ZQKhZjAAOItq/fC06jyVf554l4jl7vPloUPq9gB3MCBR43Xaou39SDjgwBOQodTNNJbNrenOiXL3MlUfxYaFy/ZP7B4zbV3PkQqsoLO2R9dXeZ6PzEPwyjCw9vRa/P0TV38Qaeujc1e0QEUrXCJA8lHZyNfk2IcRIGEU9JY+9oIn2WylTGmnpVJOJCbdGolaOXyq6w9PLgtXR1xyfomm5/WBENC38lB0ZopOXX/w62+XtzZiRA3LOZfWcRyg+STipMKBw0eqO8kdywNRTnt+PudyjGAILyFqJansX0qaYyFD+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9t5vSU8PyO1RpWtx1tKVybqONQTQnGZ4vPrqoQXO54=;
 b=OK9KiUn0vR+ySFEN0lU+h5Ngl/BdTfhH6XvP46JozUQH5FwA8n/w4vjhVFMAjRm5n1V1jvF8Y7rFDwA+4JVjt3d6kuf0i82oNgCdWDQwRsQRhQ48apDqhLlv4EIUjC+/MgBoZiPDs/Nag5LaFhQwjotE/22FwDik1D+RbUyZe5nzlrPEjBpd40a0bqZjGok0bTqW4A0tfPSlsSFfB1FsgnnBYhxHFi3mh+9MqXAoBffV/zoYxBF0ud4P+Mt+r1Pmx7UxhjY+LE7njAlhTimyZwjN+bSBF1AbXwAygYaHv3eEZaA+UCxzilsdhrJcivwLi85AOg4j9kpfISMxC45aiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9t5vSU8PyO1RpWtx1tKVybqONQTQnGZ4vPrqoQXO54=;
 b=zr+MtjJrFgMcGumQacb0+yYzN/7SUT/bnnihSzbz8HcffQB6ulFcQ45zk4M5mQFRzS3n8+8SivaUPwgmORUkheN0H44CsxUDWsLMbuZG2D6otIW5VxFu5SpoOsEgPJOVSjDi8i9o+r737Ug1t63KXVTQvVF+dJU0kdY/v7vBRpE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sumit.saxena@broadcom.com, kashyap.desai@broadcom.com
Subject: Re: [PATCH v3 0/5] megaraid_sas: Update driver version to 07.717.02.00-rc1
Date:   Mon,  7 Jun 2021 23:05:19 -0400
Message-Id: <162312149258.23851.4371504858699274361.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528131307.25683-1-chandrakanth.patil@broadcom.com>
References: <20210528131307.25683-1-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc005e28-50b4-4cde-ed4d-08d92a2a460e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB447085ED593E622CA0638DC78E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AcsLRnmU5mK/VDLQ5VHm45Z3mQ2n8+DmKnGsqVGzueoNZqSiqTzs2ek+dtNU3EP8DHo69oy+og8Lk6KtHL+S46DwOTGx0NouEwvTn6JJIQLykKPgc+5cck4ABC55Nt2ewSA9sjCZ9HhS9PPMZN97NRhGNJuPhc+Q8+4C4tovv3HwoeJ9xXp+pMd6iiBHHP+Xgr7Xxss1z+BY30iUs5EPZRLrq7jz1/un/WRMTsnYdRCnbJ/TM2/7FxJzGG0B7LYCJyxWo37PpPNSKHsC/PMwyJcvkL1TM88Bq5oCc99UOKb6L85o4HVTCxZVsF5Y1Ms60hLSt757Daqryrjo3pdkYJUZDaONkZk65omAnW8GxioxNSk5+Oj4R5KLaLZAOSGumzd/ZvqX/2KSXyJdXEH4QeeyqYmph6nsH1tG/3MzVq6TnK1AohsyrUzTOcCb1VuELyQtO8ONKd3vDB5hScYVgZ9tvLvkwwwSMxH/ICqgX+T2jiR3pnezlsGLrFGIUL9RfVdl3BbhYNL1ta+y5JPgp/MRUZ/D4vIi/MQnTKfvIN08c1Zqb655f/UngDxgt2//j0IvQSz6OHshIV7ZrbhaLJwq5PfRL9tjkJoQosoow/km97MLuo9kEvxAu5L3yZqIZEcn2eik7VpUXmybayFNCZRWMIRj7+IaQbP06wLTQJmOgmx87StIW30TClEQBiFSVBQK2qJSdb7XyjwIOQ3djlxs9azWI5RdIeWOXbuhOlpBZdV+UMF5d41nXo8tg/Pf2FQCmS5Ig/IZSSV1z/0TSMf4ZKyj211Hrdxeh8ZDElQw5FSLOQVLZLXi/eKfpceh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(83380400001)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(6916009)(8676002)(316002)(4744005)(2906002)(26005)(6486002)(5660300002)(956004)(2616005)(15650500001)(66556008)(66476007)(6666004)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bml2eFJ4TjQ4bUI3YXJQa2dhWkEwTHJ4NzdCWjlpUnpWMUlWTWVwam85VkdM?=
 =?utf-8?B?ZU4zOU0zdHNpcFRzcjAwTEdiN1NQVXBlQlpIQ3NkOEZUYjBOK2dCVUlxbHhN?=
 =?utf-8?B?SjJGUVU0QzA5dThMdTlUTXRJdTREM3ZoNnBNdTcwVi8yTEtZNWhnOWNYY2RW?=
 =?utf-8?B?dHMra3VMMXIyZFNVaVNGbE84R2Q5Y3pKUUlLYm5NWklVSmJOc1pqbHdTUVRB?=
 =?utf-8?B?aFZmTFlsNUlzNzNlUi9UcEx5SW5rWTVGTzFFZWsxeDBMZGhzR2RLc1VsZksy?=
 =?utf-8?B?T0hKeXV5Nnl3QXZoT3VZMkxYSzZoMzg2QlhnY3hUOWtkeUp4aEo3eTBIa01W?=
 =?utf-8?B?WTVTcE9EOGJsTmZXeXBPNGdwWjIzM3RqQ0tKNkFJQlpNdnpqUWZlZTA3Rmdw?=
 =?utf-8?B?UklVMk45V21LNk9wSlNodEU4RXZ3YzlESUR5eVhWYlpTZE5WVHpIanFoVVN1?=
 =?utf-8?B?WGp0cGJKVXVzTUtIZ3p5MGFNM3RqbDZuNDdWSTNSM1VKTWN5Z1UwWHBUaldv?=
 =?utf-8?B?S0FzeU1mbm1iQnZyNmR3MnVVR1oyNWpWeENmbmYzUTJ2dTg3OXNueFZ6TllS?=
 =?utf-8?B?MnVGTE5mcDYxQ2taSm9HSytPczNkc1hlem1oVjZlLzdrcEVBaktqd255TDlH?=
 =?utf-8?B?UndLck1XUW5OSXVBcHQvaVk4UExQZUVPaXpRUjB3K2htWGswSUk1NUJjNWIv?=
 =?utf-8?B?WFlvMGM0UkQvV21jdUJ2bkJweXhWcXFyZytBditnSVF1STRxQWFWNFZycTlJ?=
 =?utf-8?B?VEp6bHFMRnRuR2c3REc4V0Y5N0FjSUI5Q0QzQnNkRWNENEZyZCtsOWN4aWJO?=
 =?utf-8?B?RVpRWnhLUjV0WVFJbWJvMklna0ptVHI1ZitOYXBLRllnK0xnUHlEWXJqNUE5?=
 =?utf-8?B?YnNrZ1dKOThzRVVJSytqTlJFUGNvWW5MMzk0c1FDcGNiOUxnMmR2RDlZeW5x?=
 =?utf-8?B?ZW1CcUp0dDFRdWx3QVJYQldkTFc4bm1CNFhpNkFpKzhFMy9hbm1MLzhNRVVo?=
 =?utf-8?B?cHoxdkZtcyswWk5qQ3B0WXdsVFppcUFaMEZWZExZaDBFZWQxTGV5QmdjSDNq?=
 =?utf-8?B?dlovSWU0TDRnVXhtQy9RRjN3RFJBTTBJbnNOVGgwb3pOdStQWC9Nd1ZsL0U5?=
 =?utf-8?B?Rm9ZNWF6V2l2cVV3VktrbUVjZXdOMmZZaFZVb2FHWW9ZcGdQRXBZZE9VQTIw?=
 =?utf-8?B?ckxTa0w4d2dNWHdrZU9lSVpnbjlybTFGdlNLY2JUV0hWbDZYQ2U5KytKelVw?=
 =?utf-8?B?TEJTZWo1VkJQWWNySFRRZWNRc2ptMXBiYWtkZytQcVhUTDAzM0NTVTRORXNi?=
 =?utf-8?B?djd5NzM3U0pLM0NhVWVnRGUrRDJOVEt6UHUvRG90QzNIbWE4VUc3VExmYUZT?=
 =?utf-8?B?VFJsVlhrVWZkajZ4UVpNdHUvK2tTQjVSYUZpS1JRMmUzenNXMjlKbjBxOXND?=
 =?utf-8?B?UXRUYnpCV3ZmNGtEM2tXcXJaQ0tSSGFic0ZyR09VVUsydW5WR1IrT2N1SDNZ?=
 =?utf-8?B?ZUJDdmpEUzVuU0piUVVuclFlN2l1SnU3RzJlLzA2aDR0RjNFdXllOWJ3T3NN?=
 =?utf-8?B?SE9tOCtqN0JPeGk5cWg4S0d0U1Bvb2s5Z2psc0p4WFhpemxqU0ZtUy85KzI3?=
 =?utf-8?B?V0dTRjhvQm10NnBrMExRRTFQUkVIbnJDRkQ0cjNDalJyNnpwL0ZDSzlVN0la?=
 =?utf-8?B?RnpYNGY1U3ltT0cxUmo4enJuTzZtbW5Fc1piek9KUDU4UVlvWXBpTE5MWnJK?=
 =?utf-8?Q?aVfGp1HSuzNoM3nMQZ97/G5AWOuBcvlt76cCZba?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc005e28-50b4-4cde-ed4d-08d92a2a460e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:30.3625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: co8IwIqXd4VNC6ftTCG2u8uWnIh2ts2kII5NKP+sB38cqcZwMpc+E8wm+pBl873Fs396XuHQSUi10HEA0b60VwPFebl8Mur05kbLXvjvnm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=993 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
X-Proofpoint-GUID: VdJdT_tE6bqGCBXZDaOe2o-E6perujWo
X-Proofpoint-ORIG-GUID: VdJdT_tE6bqGCBXZDaOe2o-E6perujWo
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 May 2021 18:43:02 +0530, Chandrakanth Patil wrote:

> This patchset contains few critical fixes and enhancements.
> 
> v2:
>      - Fixed sparse warnings reported by kbuild test robot in patch3.
> v3:
>      - Fixed sparse warnings reported by kbuild test robot in patch4.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/5] megaraid_sas: Send all non-RW IOs for TYPE_ENCLOSURE device through firmware
      https://git.kernel.org/mkp/scsi/c/79db830162b7
[2/5] megaraid_sas: Fix the resource leak in case of probe failure
      https://git.kernel.org/mkp/scsi/c/b5438f48fdd8
[3/5] megaraid_sas: Early detection of VD deletion through RaidMap update
      https://git.kernel.org/mkp/scsi/c/ae6874ba4b43
[4/5] megaraid_sas: Handle missing interrupts while re-enabling IRQs
      https://git.kernel.org/mkp/scsi/c/9bedd36e9146
[5/5] megaraid_sas: Update driver version to 07.717.02.00-rc1
      https://git.kernel.org/mkp/scsi/c/6143f6f62052

-- 
Martin K. Petersen	Oracle Linux Engineering
