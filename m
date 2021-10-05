Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9204AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75A6C6136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhJEEfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:35:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1038 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229812AbhJEEfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:35:07 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1952rALa029426;
        Tue, 5 Oct 2021 04:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RA9aK1WpOfpSEHaOUitykHz3QjQ2Yx9Dms82D56YPG0=;
 b=Q7IWb3aCXDY3+jU5Bf4Y/vAi8oG6KsiVy+4OMM3kbHMkpmWjqh8rx4G+H6CkXQG1nyRL
 xJs8O9QyALM50S0oW8ZY8DwZaJhrTYJAvGwB84SVr3C/VvKn9XbxVj+Wmb82j0cKbFr2
 G/cMtYmChZq7GxVI/eyDirl9HHpJ5sV2tYgt/hr5arMqIKXzmfJTkdoBnx6b9uLY6dHk
 ZSd4ghAOozvD86/0DXhQkiulXIyXYdw6rmalaDjSEvbBkJav3WwQzk7hOtRquAshlBv/
 v+bjmvOWpNuJgYBJzx0j0ECtI501cOro1Wk9VCEEMOnjcdyUJMtHYrKKLWq4nvnJ523D lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg42kmmj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UeRG029951;
        Tue, 5 Oct 2021 04:33:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 3bf16se2aq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGCus0PDxkqcxoeZ+qtP1W4bSK6ZwscHgdHvhqwDADow9J+XEApoYY7pLmrJwKuOe28fv1xMwfn05E84jcanN0srq9VTTUHlov5oTT840ngjDtOexja5/kb6gtXED3ojAPOdS9Afj24nO7Ky0YefsesA+UoHc6KLUzPmojDcmIiqX4lXHR/7ekSKaeHme2YpjahMB26iWYBs+njL4WaoLWv/70Y5jgUjdaqxJFbK8+Qs+PgFR+1f8IjErYoAgIicpLXSu7P5hhLKPUNNUOaQ9Yazjgvyd490gKaTu7LZ0hjgeP3CEXQN/PJyuNxJ/oseLoFcBuV85+UOVCkb2PMzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RA9aK1WpOfpSEHaOUitykHz3QjQ2Yx9Dms82D56YPG0=;
 b=OAHjNDOqWDm/Rh5+Y/Ck6WVBgrKZLcI/1fQsTRbatsr/X1lSWZ2v4oghVeEK8niSgWQrcQggFiqz/c/4o3UinW6LYCnhLAAcbZ5n59gMZYIiRfV8V4M8VwIprakPVKqzclMUk0oWFkxYySbgRMOg3lYEwmPFawAVBbRYQjeTKM0JsohZyrXrFEQsrvZB7TmjnTooc1bU3u2P4xSlRYSq3e9VFmeGLXEwPLZWZQuPSp9WfqvQM7iFahOM3LN8TkrsLZFO/ccJFjbKdwMY5hoFfIy+FhpAe001ldqKsBZvlT2KlgJErAwSTDidyxfoHmvsO7Q6fpTeQoNwxdApU09Hzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RA9aK1WpOfpSEHaOUitykHz3QjQ2Yx9Dms82D56YPG0=;
 b=F3F2yfKMAZJF6B3DZ6jXmsVwn0/NxBduJsxV7rifX0YEPYkw8DNMs/YTuF2XiS5VfYaH6u+ByNvbj4kFjPvSDFdbyt/ClL7dqFzuaWKhIEeC9oYq3UcZtKirh5GZq1K/d0Ov1Isq0Zmn7xGCnmPLt066WSo9ZHwIpNxUca+x94s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1885.namprd10.prod.outlook.com (2603:10b6:300:10a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 04:33:13 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:33:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix memory overwrite during FC-GS IO abort handling
Date:   Tue,  5 Oct 2021 00:33:02 -0400
Message-Id: <163340836501.12017.15291069725772744656.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211004231210.35524-1-jsmart2021@gmail.com>
References: <20211004231210.35524-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0096.namprd05.prod.outlook.com
 (2603:10b6:803:22::34) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0096.namprd05.prod.outlook.com (2603:10b6:803:22::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Tue, 5 Oct 2021 04:33:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 926c7451-bb90-49de-d8df-08d987b93e01
X-MS-TrafficTypeDiagnostic: MWHPR10MB1885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1885E9F09E7E00630BE848838EAF9@MWHPR10MB1885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gXprb8w9Ef2dV4n5nJxCXpKMpNGwnN6nwyuVL8n266B/YrMZn330sI67CWT8IesL3N1dcfXcz8bkCY4tNqM+1KLdP9oMJ5uoLQIjR1l1dFI+k+vt2jKtsO1IKog8Qt4/t+sWTj1ptbcSJNYMUDpnDpwvb0G3VXxTkmNKsBsZHPX69ZxfOF9PbGSIvOolC4lv6/WNgGIqWenWiv0IDyHSJ0KdjJo+mDd0ILCXOO9tnWLypiULSYF3WrfRj902XWopLkUTXd9oKBLW/83e/uOZo/XWO4xvG89Nbf/bm+BODXJsjZgtKYzeTKlIi3oHchXuOcO3PlKevOGVndrWR5SnEAL4WiNbzfLAHRqp+t6YKNERKjC2UKlMUH87FjHfG6I35p4RuSZJz5QYJuk1th4+qodGB4MxnQjYxA3at01/hQgKloxWObvchygOn4GfWpMmMnzel1yYKfBN+OB+1HI27F3P/IH5OlMUagdL2VD3IzuoAEPinuksKHg7crheDQpQTF0vWH674pFXlJcxrwgB+yaRvdmUyzTwkQnmjgPRyBLTNzz3VQZaQffkw3jBpkP2MbvT4m4eQ4UumwJ8D2O+s4qNHikRPgrGI0ZsYSzySSNLwHhxH1raJZVhnd+Wk2eXrQa68K0k8NHRUjevD0tmtHRRxXZbgGDwnHNpjyBQmQLSCYOrW+T0UVr+W6V6QPbhuCO5lgKPOaUSb+jhOXAjOfAs72dIt36VL5YtjZysBRmyz/CDVPYcT84G8zZxHrRs8o0XLkSMYyMsaJPXO5qKmJbyHlL3+0KcGxa1SYPCPH0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(8676002)(956004)(52116002)(7696005)(54906003)(6666004)(86362001)(2906002)(26005)(36756003)(4326008)(6486002)(4744005)(38350700002)(66476007)(38100700002)(2616005)(66946007)(966005)(66556008)(5660300002)(8936002)(103116003)(316002)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHd5cExkSG5ENDY3dkcvcG1zUmxOMk5PQS93eHZwaWFidXR6bGNZdy9BMEFD?=
 =?utf-8?B?QVdPR2Fvem5rbXNyMnIvNnZ5NXlsZlZtSmJFTnMrZlhQclNNcnNQMFVJTmlm?=
 =?utf-8?B?cWREWU1NMUI2dWJVeWsyVTM5SFRxeHVYeDE4aEIyajNrbUt0VHFMbmEyWUls?=
 =?utf-8?B?UG1xenFZR01LUzdSTFp2T0NTMVJlajI0NkF4K3ZCeXhtbUU3YkI4MkEybWxj?=
 =?utf-8?B?YVg3Z0o5RXAwNFRMYytwakUvM3Z5NnJHTmRHR1hTSVhNWU9wZ2V2ZFBUVkhy?=
 =?utf-8?B?WU51NmY5cEZrL2JwaE5KRVBuK2VISW52TDlFUndXZHFMM3NTdjBOdXFvOVJE?=
 =?utf-8?B?MXduVjROSFA5L1F5aVlPVWxLZHRhdWFCUm9zSVE1S2Fmd2Ntc2FTU003ZEEy?=
 =?utf-8?B?Z2tqcEVBWDMwam05eFZJbFBsWXYxQzUzbm9teHhvWkovRktndWxIazJrSmRu?=
 =?utf-8?B?MWJYbVA2eE5Ha2lRNk9OT255Q0RLQkZpSEhrNEZsOVBIUnhDMW42TkcxanpR?=
 =?utf-8?B?RFYxclB0QWpNRGhDWVZlV0R5Qk1GbEllQlZuenNadHVtQTdxL0NzUFpxMEpH?=
 =?utf-8?B?eE9HY08zMkwwQjhHbmNqeUNYbG9iVWsvVHJpc1REdmp6MUhpS0R6UDdCeXBJ?=
 =?utf-8?B?c0FtM1lpMi82bEFlRmtaL1ZhMzUyOXhJeFViM2ducVRVUUdjUVl5UE42TXF5?=
 =?utf-8?B?UTM5UXVpZkk1cXA5UzlaMWRnWGw4d2JEVitibDAyOEx1b0M2VFZ3SnZrVDRa?=
 =?utf-8?B?N0owNUZSaUJIclhWaUV2K2VkQSswclZta25XREFKdVg2OFpOZys1WDc0NzY2?=
 =?utf-8?B?ckloSEkyYzlKcjNKTUJNaGhKOEIwQWhlaHhvMWQ0OGxtMm5GQ0c2eW85MDlm?=
 =?utf-8?B?Y2hLYTB3RndJeE50eTJsY0Y0YXRablBwbkJKb1RuSXZJSisvVFFJVUFKaXc5?=
 =?utf-8?B?M1cvTHhyZmY0TjhPU2dyNk00SURCVzB4anRKNGxMRFBxWWk5MjVFOVJFZFFl?=
 =?utf-8?B?eXBEUnA2OVR1eWVodVNXRW5XZUEyUXgvRkVPUUtFZDNFZHE1Umg2U3pYSE90?=
 =?utf-8?B?Nm1UcXk5bDRTamZvYUptRFdDaXZqN0tjaUdoeUpIMzZPbGNnMFRMSldiaW1P?=
 =?utf-8?B?NmpQZjl5MGh5WUVHT21GK0ZmWFV6bWVQVzJSSjJJNVpXR0hjZTAydjUzSmNm?=
 =?utf-8?B?d1ZLRTMvRkpYOGJCby9pZHpOd3Y3SCtiODNRemFDL0Z1dkNVZTlTUHpXeTBN?=
 =?utf-8?B?Nmx5T3J3azVaYzltenhCMjlJdXB5dGk5WkdqeXdVZlpWTytFc2lQUGFsb05x?=
 =?utf-8?B?UnRVK2V2OFNaN2RQTlhXMk4zYlliUGZUaktCeHVoT25VdXRGTTBCdWxVcDVV?=
 =?utf-8?B?dmc2UG9NTHpxQWRhZlhubkFBRXZSSkFqUG1LRWF5VlJqRGZ3MThyR0lqRW5s?=
 =?utf-8?B?Ri9wa2VSMW9JSGhYSHdPamJ0SmNiT0RreU15amJRbDB4QitxNTk3SzFOOHoy?=
 =?utf-8?B?bkptQ2tYamFKMFQvblExbTRxaUhPbGlLTkt6eEtnOTlSWmg4MlBqYk5uUEN4?=
 =?utf-8?B?V1h2djZxWHNhemVmYkN3VDV5Sms0T2ZwWlBiTVdJbGVRakVNOXRFOHJ1Wmlw?=
 =?utf-8?B?aGVmc3A1akVxeEtNWllaSEJMbmxpZkg2QS9raEgxdUs5UEtrK2pINjdCWE5q?=
 =?utf-8?B?R1k2MVgwbDhwSHNXd2h0UFVoV09haVpkWlVMQWttK0RWUzV3YmlrNVB4b0Fx?=
 =?utf-8?Q?kysVuayPpRBOsWMcc3LAyltV5ip6uc4p9i3MOqs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 926c7451-bb90-49de-d8df-08d987b93e01
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:33:13.0824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ny+4UhjCajOK/7vv2uOu3ot6jZ4Zl/dS/YIBpbF3euEB6s1Hv6X7Pd9oe94PP7JLXzSWI6N9gtKmP2gi3hRSBZaCP1Y4EuSFIm8czzER3d0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1885
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=653 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050025
X-Proofpoint-GUID: hCCjETqqc-igb1ygGnIEpYseW-w6jbHx
X-Proofpoint-ORIG-GUID: hCCjETqqc-igb1ygGnIEpYseW-w6jbHx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 4 Oct 2021 16:12:10 -0700, James Smart wrote:

> When an FC-GS IO is aborted by lpfc, the driver requires a node pointer
> for a dereference operation.  In the abort IO routine, the driver
> miscasts a context pointer to the wrong data type and overwrites a
> single byte outside of the allocated space.  This miscast is done in the
> abort io function handler because the abort io handler works on FC-GS
> and FC-LS commands but the code neglected to get the correct job location
> for the node.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] lpfc: Fix memory overwrite during FC-GS IO abort handling
      https://git.kernel.org/mkp/scsi/c/69a3a7bc7239

-- 
Martin K. Petersen	Oracle Linux Engineering
