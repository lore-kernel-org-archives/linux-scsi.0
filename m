Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99222C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 14:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbiESOA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 10:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239527AbiESOA2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 10:00:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0871EEBEB8
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 06:58:34 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JD9tVs012673;
        Thu, 19 May 2022 13:58:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=8BwQINP5+SfXHvOxPYHMkqgumVo4VwUBTG1V6EphY90=;
 b=s8Hk7XpELdYtjTzRRONIKJXVY9+Rov7iEma9G20oueQtCDnRc6OLIi401tBJ97EeV1y4
 tuKKT6+jeszSWHipufxc6Q/XZkTUIlwfMOlEoHs6wS+9vnGGxXbHslkPrw9TfeTV1NWy
 B/iHoBWzmYoNOPVXj/kPMrlIR+fuxrCc24OfSAqP+uybsigeg/cjpjnHPLS/1pJFdkk5
 v89vkoVVDoLNbVOASGK8ItMbAb91ofIKvo90DQ9cp4fzY4NtIxH/zYt7DDvO1nMBJyOl
 S2swE3nbcngmy8nA3ayNN9v/dukfbQUur+643GlahAAUmSsW+TG1tg4bVHbrTQc1LshC mA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aam12f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 13:58:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24JDtb3e010771;
        Thu, 19 May 2022 13:58:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v52uh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 13:58:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+rXAS+KUhGMIUUM3cR7NOKKdECcjOobyvgnzEc1H21MLB6t36ddXbaJXJiCx5GdEdSffq+qeXkE16GX7qyZKJEfnwcn1AM7QhHc4H2dElskFBsTkTTlmcVJpOIg4YsAxpgz68e1HFG7KR8HYq3noJiigHtHfGuDp1zl2OGq/pjual2oQi4vEQsmHGGTdOgHskW4W/HnHnvraH8po+bKBG9ONWBKdy21STbQ3T/LysqEamUK2BDawQoyyZwJReUGG9KDDQ8gn99qH8qM+GvosprwSM5UwXzYBMfc/+/XkVzazNX/qfZrDfKD4R+OLC/MVqRvGSbo/rL8oM+I+i/JjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BwQINP5+SfXHvOxPYHMkqgumVo4VwUBTG1V6EphY90=;
 b=QScF8aYa4g4GnJR5bRjsmheAfQssWtfSFgG7dlesT3UHkAYICi8oQn/tG4g1IMwYpIZwvrJ4FRnE6kG9tosiB0DwM/TeEF3gaPo44wLKCqqebe+sGJKbek97j+5gycnBFpIrWmNlHxMU61jWmxjaIcw/ooOhavcV1XkCs27n9zRz8Xmlz5avzp/NzpsCLLLmaqamGreyltNTutlCFgwCiiOizPpXrVOBX8YZRKl89joxtCC4dRi3gKZc0Due0R8eqXbRt2HklrYnFB++Pqbe88V/Hslo3xi0TYo/qR4dtrF+NydMj8kIPG39aIIRH52Qpn3hjgECcL3VGDS2MpXLfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BwQINP5+SfXHvOxPYHMkqgumVo4VwUBTG1V6EphY90=;
 b=ux376iDxDdMUF6ibS/PMgtucHJSGz4ACkvvXcPHR8BJqsqE+aq7uzTZcK6lv8Kz56NrB9liMu/RQFbS6WBPIQXHWGGSfedUzQm2nHsPZe4wouad0KJ1YQ2ZzR/wYewOC023CcI9A7L7cryUhzAB4SVKjN0nY2TZL9GaiZDaH3Ao=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5277.namprd10.prod.outlook.com
 (2603:10b6:5:3a2::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 13:58:30 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 13:58:30 +0000
Date:   Thu, 19 May 2022 16:58:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Commonize VMID code location
Message-ID: <YoZM9m49PjYMKqxn@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::10) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bafab45-ee57-4fb5-9a21-08da399fa7b9
X-MS-TrafficTypeDiagnostic: DS7PR10MB5277:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5277067AC3497472641D61AE8ED09@DS7PR10MB5277.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+YoTzM6mT3tmsX2vPjJszPsQ3ZxXNwU+1niDqw9myAnoFDVGDPs3DYZmIRaD/ei7Ngbl2tCkVBIdBGe9Q3OsDeRX4sGXaJLkN55YohO2b3XIbAvRvOUuQp9xeS5SK8Bv/PgzRlTwYAIplJh+vqrdJjtU+is9UNIsaHvcHANSms0uMHFfZ/VWHT6smbHf/ygj1Sa8auBucgOVWLZRbP/B1UMeEk2jtGDna7Zxo7lROwBlCZduEv6y/ZMCwmk2/xrbYdww53PWd2IhVKws/nBQfHoRCKaW9SA7NLnl5WbfXnm5eMf/C82e/IyAkCwstuWl/7fJXNCWqBaO3RE8tdPwqLcC4O38O8tmA1MiT+OXDfWMvt9fR4mK8zxNN9lrUYCkhXQFSMEoFpxrp8Eg2hxnpqtSgMuqWiK671Jyzmo4m5VFz1VVX+JlgvDWwMSOhTy6QJBgUwEot+oFiV5gSsIhWxQuVjZ92Um2Ixz1rOqVTGKUOUYYdpzUUCgut6gwddUW52vJkjfg8Wu+3xg95n7ngzFbtfGr44j9ObnFASS6zzXYSHQHrd6/ZeijeopdvJknJ9/515KjkAnN2hu4YOKsRNs6Kl86iCO8IwgFzt7XlhZqyPwE2AyqU0ISAamoQ+MC9SwR4n3Yf9plZom+/VsrY+uFwnlWHz24JbwhpzMMTg08HGOYk1O9yQZN/XbuvaL+NsFOXvdfe3JkFKniM/ThA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(83380400001)(6486002)(508600001)(44832011)(8936002)(6666004)(38350700002)(2906002)(6512007)(6916009)(4326008)(66556008)(8676002)(26005)(66476007)(66946007)(186003)(316002)(9686003)(52116002)(6506007)(5660300002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BVVaNwSJdZHjAWAEz7RldueTlQGFVFvQCHKN0DVb1C5tf40HQAXUCuxhfM/9?=
 =?us-ascii?Q?0wDUPg6xLAoBm4+ieBL2js/B/FMr6nFueyjqwbddMTnjIKjCy5HVfuIiMHJQ?=
 =?us-ascii?Q?ukBGV3XRq95RuaEbnLodAfc5uTCBC+P/0XHQ9H3MOUsKkdVIdw6pK3M9fuIF?=
 =?us-ascii?Q?SvsHqMw4FnVTocr4F20EhRzowHS9uEF5sN8rauM+7AKy9sUdZ2Rv8FYSBfwB?=
 =?us-ascii?Q?6JWrp9XMObs/1ZqDyAPuPEUthQhpuSk7OVuaHtOT+fiOFavTlWJD8qU/fbRB?=
 =?us-ascii?Q?gN9QTHR3Na41IWPGy+ur96ij1FTuUkvHQv324cWLKNdLifXd+hZhTeJ9Uio1?=
 =?us-ascii?Q?/Quwnb1cfjqJaCADU685rg1Gc3m0bPvN+HcvldqIIFgrSo+s2HJyJBZhjV4+?=
 =?us-ascii?Q?QYaJp+6yFVLR1G9kyDjZ8lHyKANxcdd2ddp4IOi0wAXEBgtXg/iHAQrqoc5H?=
 =?us-ascii?Q?rRdFAnID+R4Xa9l1Oe17V0Fi65aRvg6u+HtlJcVRgAvRyHGyexYF+iRv6sAK?=
 =?us-ascii?Q?N/mYzMz0kC8szTrbTBrRmVldncBXOp0PHi+c5WePkSky0RoFkU0Hp3qL206J?=
 =?us-ascii?Q?lbrkb+r4vgSQJsHusFq8VlTPJf9L0Wt3p6cPIDDKpiGmaJXHfdXfr3e5JhI/?=
 =?us-ascii?Q?EEk42I1I7g7y7qX4fiJCC12gdyLvcrgtsi9zvhkcEqtwy1XgokD/7rDhQely?=
 =?us-ascii?Q?k7TSBqQSdHB1I9sWKELlEHOIHGKRO8ZuekHrvg0nkELD2wnONDe82ulgGFQK?=
 =?us-ascii?Q?uN36j1plHkCWuQmE34YXFPjupb/fCHg/cb6Ou+oswwliVkmBIlrv15S/SDqD?=
 =?us-ascii?Q?KgrA+LV1qj3A8E37c4z7COopyXTaaZiK40nUZ0ml/QfXiZbnYltbyoPHV82C?=
 =?us-ascii?Q?LJYse42nKHUpvypfUtjekwtSxxb2w8mjamA5XwDMpD1QcX5/N/J4cRKKdf5q?=
 =?us-ascii?Q?93PKNMiwHMm9kJ3T/iawiGt0DLV6pc+exmS1nbep/YMuhdfpm1mbKH9H1Kvl?=
 =?us-ascii?Q?h+WG895dNAheA1vCvkygSUyUDKs3eGQDyKzvqmgWWuNzx5gsvzdYiVxU1hRi?=
 =?us-ascii?Q?R9/m6oKX4oZOQ4KYGCPW9lojI/aVfUuo1ZtwKjAVBHh6s2ePlatoE0Ud+eQx?=
 =?us-ascii?Q?B/n1hwYhouAQAKc4wk9gxxSda92/zJTTx3YXvFNdew7flCA3sVg5JIYv/TX5?=
 =?us-ascii?Q?fmTDpqop9BR+Y4eDtfLID78fqgwQTDmyAj6x1j2RUYPLThixtOMyKm+L0aF2?=
 =?us-ascii?Q?6edYQ4wRz0FxMrRytj2LeiGnydqE33nqx44ju03hhUyDmNsUFK3yajx7+zdx?=
 =?us-ascii?Q?ETOmu8CtuahE1hxvebdptInCMnpojvsieQjCP6yEwQ/MPWE5UgXEwKVjj9dC?=
 =?us-ascii?Q?WbwR2PI9BLBGSzL/tHwko21qu0lMOA47AIFA1TSqUIYHdpMPmpWK7b57pD34?=
 =?us-ascii?Q?gO8dIfdlRsFaoVYgikKpM/shcnvgKQtYvCJRVaIiVj/QlXzf2hEVzA1Gc9eQ?=
 =?us-ascii?Q?/BzwuKOwWL6Ye6FkUbD8hHXVQK3K3Uf/LtMp64eDb+royIrE4pabIp5Wbfgx?=
 =?us-ascii?Q?IFbOfJVTeImMArUbKZXGPWFKyUy1bm+xQsc22q11Ryav4xlKW/ynCo1MN7Ap?=
 =?us-ascii?Q?V+wZ/vJ+veRH9vhA8rli57evpwbsDowXuWQe+WxvI67lrKDREtVqVtYWyqXR?=
 =?us-ascii?Q?X0Z5o9yuSmzyL40tABPCy2e7zTgZRw4r3ESHqn4Oz3pUWWInMRjnjx/gm1+l?=
 =?us-ascii?Q?Z9uxknnjDIEzHohSIVAGw98HXEuOrNQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bafab45-ee57-4fb5-9a21-08da399fa7b9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 13:58:30.4138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: no4uvAK8xGa+oRJWGMTyABlBUpuS/Huwx1H+ILpxrCYT8T4lCFzKlfhHgkSk8R5FuST90jd2s7/O7O5DBSpWi+8TjBnbmuCbqOkuFA2PI3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5277
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_04:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=866 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190081
X-Proofpoint-ORIG-GUID: C1lRfbHYnLctsoKFb9GxzHztPDgw7TH2
X-Proofpoint-GUID: C1lRfbHYnLctsoKFb9GxzHztPDgw7TH2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch e0063f4ad51c: "scsi: lpfc: Commonize VMID code location"
from May 10, 2022, leads to the following Smatch static checker
warning:

	drivers/scsi/lpfc/lpfc_vmid.c:248 lpfc_vmid_get_appid()
	warn: sleeping in atomic context

drivers/scsi/lpfc/lpfc_vmid.c
    192         } else {
    193                 /* The VMID was not found in the hashtable. At this point, */
    194                 /* drop the read lock first before proceeding further */
    195                 read_unlock(&vport->vmid_lock);
    196                 /* start the process to obtain one as per the */
    197                 /* type of the VMID indicated */
    198                 write_lock(&vport->vmid_lock);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Holding a spin lock (write lock) disabled preemption

    199                 vmp = lpfc_get_vmid_from_hashtable(vport, hash, uuid);
    200 
    201                 /* while the read lock was released, in case the entry was */
    202                 /* added by other context or is in process of being added */
    203                 if (vmp && vmp->flag & LPFC_VMID_REGISTERED) {
    204                         lpfc_vmid_update_entry(vport, iodir, vmp, tag);
    205                         write_unlock(&vport->vmid_lock);
    206                         return 0;
    207                 } else if (vmp && vmp->flag & LPFC_VMID_REQ_REGISTER) {
    208                         write_unlock(&vport->vmid_lock);
    209                         return -EBUSY;
    210                 }
    211 
    212                 /* else search and allocate a free slot in the hash table */
    213                 if (vport->cur_vmid_cnt < vport->max_vmid) {
    214                         for (i = 0; i < vport->max_vmid; i++) {
    215                                 vmp = vport->vmid + i;
    216                                 if (vmp->flag == LPFC_VMID_SLOT_FREE)
    217                                         break;
    218                         }
    219                         if (i == vport->max_vmid)
    220                                 vmp = NULL;
    221                 } else {
    222                         vmp = NULL;
    223                 }
    224 
    225                 if (!vmp) {
    226                         write_unlock(&vport->vmid_lock);
    227                         return -ENOMEM;
    228                 }
    229 
    230                 /* Add the vmid and register */
    231                 lpfc_put_vmid_in_hashtable(vport, hash, vmp);
    232                 vmp->vmid_len = len;
    233                 memcpy(vmp->host_vmid, uuid, vmp->vmid_len);
    234                 vmp->io_rd_cnt = 0;
    235                 vmp->io_wr_cnt = 0;
    236                 vmp->flag = LPFC_VMID_SLOT_USED;
    237 
    238                 vmp->delete_inactive =
    239                         vport->vmid_inactivity_timeout ? 1 : 0;
    240 
    241                 /* if type priority tag, get next available VMID */
    242                 if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
    243                         lpfc_vmid_assign_cs_ctl(vport, vmp);
    244 
    245                 /* allocate the per cpu variable for holding */
    246                 /* the last access time stamp only if VMID is enabled */
    247                 if (!vmp->last_io_time)
--> 248                         vmp->last_io_time = __alloc_percpu(sizeof(u64),
                                                    ^^^^^^^^^^^^^^^
Sleeps

    249                                                            __alignof__(struct
    250                                                            lpfc_vmid));
    251                 if (!vmp->last_io_time) {
    252                         hash_del(&vmp->hnode);
    253                         vmp->flag = LPFC_VMID_SLOT_FREE;
    254                         write_unlock(&vport->vmid_lock);
    255                         return -EIO;
    256                 }
    257 
    258                 write_unlock(&vport->vmid_lock);
    259 
    260                 /* complete transaction with switch */
    261                 if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
    262                         rc = lpfc_vmid_uvem(vport, vmp, true);
    263                 else if (vport->phba->cfg_vmid_app_header)
    264                         rc = lpfc_vmid_cmd(vport, SLI_CTAS_RAPP_IDENT, vmp);
    265                 if (!rc) {
    266                         write_lock(&vport->vmid_lock);
    267                         vport->cur_vmid_cnt++;
    268                         vmp->flag |= LPFC_VMID_REQ_REGISTER;
    269                         write_unlock(&vport->vmid_lock);
    270                 } else {
    271                         write_lock(&vport->vmid_lock);
    272                         hash_del(&vmp->hnode);
    273                         vmp->flag = LPFC_VMID_SLOT_FREE;
    274                         free_percpu(vmp->last_io_time);
    275                         write_unlock(&vport->vmid_lock);
    276                         return -EIO;
    277                 }
    278 
    279                 /* finally, enable the idle timer once */
    280                 if (!(vport->phba->pport->vmid_flag & LPFC_VMID_TIMER_ENBLD)) {
    281                         mod_timer(&vport->phba->inactive_vmid_poll,
    282                                   jiffies +
    283                                   msecs_to_jiffies(1000 * LPFC_VMID_TIMER));
    284                         vport->phba->pport->vmid_flag |= LPFC_VMID_TIMER_ENBLD;
    285                 }
    286         }
    287         return rc;
    288 }

regards,
dan carpenter
