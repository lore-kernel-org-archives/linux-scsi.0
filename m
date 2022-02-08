Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72218C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352791AbiBHReV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbiBHReT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:34:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276ABC061578
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:34:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218Gf12B011047;
        Tue, 8 Feb 2022 17:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3A+cupsmbVpFFrP0l7Gj/LLPylZLnlqICQdllJHKq4A=;
 b=sxLdrhSPC28zZb456DzZIA97nZl230hW/ltUqWECRFGqnU//8VLEqrMtvpJVBldPAZXA
 e2JJVuhbAdzXorezct5+L3/Mqv8kp6QGhZPRmgdWWs0/0R0Rtzo7cjyqzN9PF9S1encZ
 FRQSffHoq0GDydVLtKXeHvxArdGxtT5bY38LUqVy1XN+PG81oxVSqCYsh6cqbm0gvq/k
 g/OJ/Km+Tf2vysxtgCO0HH1Z+Q5PC3kCBY6AhsAqUOw155/tAGgzgWpCLgPrX3VXZlxR
 gIp1HrPFv/avnfl/7vByHrZwV7pQrjcB0kxgs4KNQpJnsdUUPRo9iCwcchzfdZCsT2Ph nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdst42j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 17:34:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218HHUmh043753;
        Tue, 8 Feb 2022 17:34:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3e1jpr6vyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 17:34:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VF6hE1wZDNGQPz/qOOEF/ZhhrIwtrUI2xCT9d5SE3e7QjfhIyK8PzPzP1YasThSr3ICNlJ0kj0gfL12oX2XKfJICtlmTV2oyJc7HNcORLpWk8uHdSs+vy1108UJ2qK28iNAKplM6BPHQZ8UsAkQBl7mGqvmv0/zetPK6ODeci+KGROM5SCFW6Nh1C+dGXzAc8KVQm6EPF0n7VtS0F+y/SE8yti3EXfVqP4fZr+NMcqQx5t1b9PonRByX8M3kZQqvMbzfJiwg1wsUmYNrP4Nb+gMuov4wFNHOgdFF0M02iWAtOfx5AoDM29mhcJa0TOgyRBl4ZHxquL8GPQQhrshZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3A+cupsmbVpFFrP0l7Gj/LLPylZLnlqICQdllJHKq4A=;
 b=jr9AdRgRappkEsGzs0XbnEMJm8KeQm26/BXUu9LDPwJOGjFIjHnkrpiRDZF6+i6OerGNBqe2YGgrq6sP4z2w0ZU7d1CD21jXTAy0OoI49Z3PDOVud5VxDywPbjCRK8DKCSB/08Uknu8mqHMZ1h1zmGQTRA+rbXTdnW9WFMEuCopuObRyfLgnurDT471CLmwMatFRHtoRA0yb2HrI7tPxsUafMN3wuWXnZKs6lxB0rw+lP/aFPgcJ5/dYz+nhFyGaprpgCSIZL8HzGtb4uUDnjof6RI21Gb5m5NmmCqUBpV9Ndsa0a9PAMs1mJbkh62tOP0co9YoZvB2iq9LtyIs9mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3A+cupsmbVpFFrP0l7Gj/LLPylZLnlqICQdllJHKq4A=;
 b=Kr1lUDUf4/+tnWQ2KBmvwfF0R5ZSpNF01N4V2SakPhhnG9Boiyqzod2rF9B+GIF7UmvOuEhg9RVzCF13kVvcoBDNhxKA70XWak076ahzqEp0VPloIqzx7tG5zux1hLzvCeoe3cruUrii01JppJdO4JHk1XxLIwHNpsEcFu0+jUY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB1353.namprd10.prod.outlook.com (2603:10b6:3:9::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Tue, 8 Feb 2022 17:34:13 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 17:34:12 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>
Subject: Re: [PATCH] qla2xxx: Add qla2x00_async_done routine for async
 routines.
Thread-Topic: [PATCH] qla2xxx: Add qla2x00_async_done routine for async
 routines.
Thread-Index: AQHYHN6rEmUpdRXXy0mLdGFPJQFSYqyJ6m4A
Date:   Tue, 8 Feb 2022 17:34:12 +0000
Message-ID: <14292EE3-5AA2-476D-BB7F-2CFBA54C3AC5@oracle.com>
References: <20220208093946.4471-1-njavali@marvell.com>
In-Reply-To: <20220208093946.4471-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7068f6f-f2a3-42d9-ca11-08d9eb2938db
x-ms-traffictypediagnostic: DM5PR10MB1353:EE_
x-microsoft-antispam-prvs: <DM5PR10MB1353224AF7CCE257B0763754E62D9@DM5PR10MB1353.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l1tidH2WVkN2TDDvvznRsCJrkm8Dcds4cuYPXSOHHFFLxn7xzwqNtWcQJ29+XjcIaAcYR8DOqX+WluSwUpYUtFL+zNrd5a332OlZGqZaqYwTFMiXsOJUX9RNSyhfH4Y21sgrkfcxm34muAjyNwjIsw2nDxIn4mMbQ4kpbz+OXYXghCXF7XdMrbvBXnTE3s3FsCFIPw/xF24Vz3Cb+HAg/4+89dLE7DC2MJxLPbt6Rc1nrnuZndRbRvrMO9YvvJQabvjd+GFntLzsZBDjuAxE69tJwc6d13ze7sVAodY5wIcxPZ8mIHSwOFnpjfhgBhzV4NA5wskBtThMAsOhKyzscRAr92cjd2aERonySJIcUbEdfkWR5dwnVH+amlAY8TYMeDUBFW3ce3we2j+ivH0EbyGm+Dl//HggayLfrdrs0cX2SmaocMa81ny7LW15EK+Q9kQIY/olbEvgpdpPmKb/+eH6VBYudPowbH7j8EhurmAgjrHA2Vq1WDN4xMcuH+OOQGcnXI/5NCVySRP2yTNBjUGs8S9Om7M1cb6suSD6pFLJ+ezmbzKZglEAnXSY82BtjKggwpgU1tINN2Gy+w2BFpJnwZ3J0gltsBhY9hs812wnjUmKtSEwVtxv9CEa0BmpgPoWWY70ZBDw6vPx+ERADWbkkXNhGJZ2GdFcJCBvIlThTa7TAvKwUDwvHyD9ehNJbzhDKl+fant8xAagNOH4BoUJbYXwoW+l/MdgA2pZDeg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(33656002)(86362001)(38100700002)(122000001)(71200400001)(8936002)(44832011)(5660300002)(6512007)(6506007)(53546011)(91956017)(6916009)(54906003)(316002)(6486002)(4326008)(64756008)(66446008)(66476007)(66556008)(8676002)(66946007)(76116006)(508600001)(26005)(83380400001)(186003)(36756003)(2906002)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWpDWGFNK1h1NzNwK2ZJQTdHUmJHVTJuTWFtMlVZYkV2L0pRdWgweGFlNUpX?=
 =?utf-8?B?Tnd6MHdjNzJHNSthZUVCTDlPajJETEZ5M29pTDFEOGEvT2ltUGsyajFFTUNC?=
 =?utf-8?B?c0ZkTXRLUUlJZzJNWnFGcnVLRWVHTkFVcjBGMFFvWWZNVk5ERml4Vm1sb1Zt?=
 =?utf-8?B?VDZlK1I1Wk92S2p0cW9tMVZ5OWs3UVk0MlpSZjNXdlhDUmE5VnZmY1hDQ1Fs?=
 =?utf-8?B?U0xGN05XNDlOR2N2UEpUeVR3UTN2R0tiNWNhZ3NHNFhQb05nYVI3L3JxQmND?=
 =?utf-8?B?YUovQ1lHUElOaDZjcGQ4a3pJaGpuL3plSGUvZjV1YjJZUmszckVmSEVxUGhm?=
 =?utf-8?B?bXlRRXpZRE15T05WcWZBc3ZSUnF0blVDc0lMUmhTeEpZR1k4aHdBVU90WUNq?=
 =?utf-8?B?ZE93SUtiYVkySWJlQUFNeUJtNTVYU044NTBPSCs1VGNNbXlOYlFWcjNLUFNQ?=
 =?utf-8?B?WEpBKzExUHhJaEhIaS9tYVJROFU4c2QxOGJVWG5ncGMyTXgyRnp3dEMzQUQ3?=
 =?utf-8?B?cUhnV2I3VjV1SnpNQW1RZmc4bFJIejlNR3FKRzlGRjVkYlBYcXdqcVA1aHR4?=
 =?utf-8?B?U2c5RThJcHU4SDBqK3BxemJkaTBzSHdBRStMeC9MUy9seWpDUXE4NlZvTXlL?=
 =?utf-8?B?V0U1WENReTlkRXFqcjh1U0thd25COVdWRmtueFU2Wk55NzIweXBaRy9sMDlQ?=
 =?utf-8?B?RER5L1RUSVROc2kyRTFJbU1aS1FvVDN4eUhjSkZsRUVLWVZXNlkyYjBiZXNn?=
 =?utf-8?B?OFpZRVpXaWxFT2F4T3ZoVzJHMGJVWWxiUHg4N3hzdGg0RzRHRXpjdVBCQUVn?=
 =?utf-8?B?UFI0ZHo0SFRMdnZMRFVjTC81WHk4MWhUNzJheGF4bitwUit4UkdjeDRkL1kw?=
 =?utf-8?B?Zk83TzdmaFMxeWxwSmo1ZnBUSFNGZllhdkVFRU50MWlNRWxiWU1pd3lNUWFB?=
 =?utf-8?B?c3RYT1hnOUU1dDJpU0JpZHRudU0vdFUrUjk1STlzc2dlRERGQ1Vudlg1a28y?=
 =?utf-8?B?VVpVZTk2Mm1ta3hUQ2dHMUd2N0xHZnBlM2FEKzM0VFV3K1BCZU1lUlM3WTU3?=
 =?utf-8?B?dHAzR01HWisrc3k4WTYyVDRFaW01aHRZSHoyYU9lem5pbk9vOXlTdXdKYUhY?=
 =?utf-8?B?ekVidmVvRTM0dHlDYlZ1ZTBadm4rcnBTV0JVMkVHV24rekFZdFo3WDFxeWRV?=
 =?utf-8?B?OGo1UTd5ZmRnYjhleklnMGxaSk5BUm9IRW5tQ1NBcUQxem8rZDZYUlBBRXVo?=
 =?utf-8?B?VHZRek01L2FSZnZoSy9qOWdKV2FLMzZzRXR3K3RqZ05QNjZsdHExNVpmUDBs?=
 =?utf-8?B?VUYrMEtUVlVDWWtmNkFETVRLYmxwUnBNVTRwQ3hQd1JsQjdMQXBsTDV1WjNv?=
 =?utf-8?B?dHVPVFFramVjUGZxbGdTS201c1pBZEV2UU45cUpkN1J4R0JoTW85U1p6dzJ5?=
 =?utf-8?B?RDdSQmk4cGNXMk9Hby9LNEpiYzZsZXZ4b2RtaFBTTWNqQWVSSlMzSTN0MitJ?=
 =?utf-8?B?UVBFdUdxT0Y1dDAxVnowVGp5TCtPL2N5cHkxUnpOUU5YZ0RuYnMrL1J6Umg1?=
 =?utf-8?B?MWlWdVFnS2tEYlJnNUpYempWM2oycE14bU1VdHV0SlRNdXpxNFNzbHErVnox?=
 =?utf-8?B?VXVEUzQvenFMdWVVV3pmZ3RJSFhYaDl3NXhlVkhlWkJvc0tFZlVmNzZxMkpw?=
 =?utf-8?B?SDk1cW9xbm1EK3Nxdk5pcTc1clBOU1l2UkIxdUxEZFI0UjN2TndsbGlzRnVD?=
 =?utf-8?B?YzRDVTQwcndreFRxWGJzNW5YTXh6a3ljcTZQaE83L05lYkpUMGplaGRDcXV1?=
 =?utf-8?B?TEJEMXdObVc1cnUwbUVIR2wzcFJReHFGUXNnT2N2b05PWFRjcCtDYTJ2aDh3?=
 =?utf-8?B?YUJkMlJac1ZyclR1TVRhSkExR0tOVUx4clRXQVpmRXZ1cnk5bUlJU2wzU0lO?=
 =?utf-8?B?bGtiZktGdDk1L09DMmcwaXQ2Q3FlVkxuNXFnS0JXcThBMTBYRHhsdzJxaDNL?=
 =?utf-8?B?a21pM0V6emdvV0UydVlnODY4aEpZdFdNY2ZvdWhtelpBc3hBMWF4aUZNaGJD?=
 =?utf-8?B?dStDZFVaT0VvclhRMmNKWUl3YzdGVlhVa1MvaXFrUUt2L0xQa295TEw1anRK?=
 =?utf-8?B?VWp3YUlmMUU2NnN6UlptczFyVzFUME9LRlZXRkdGUFJVNjU1aDVWZ0JjOWJs?=
 =?utf-8?B?UHpLdUdZLzBKb3dTTWw5QTdqdWRmUFRTVmtHOW1WQ2xPNFk0WXplM2hFWm1X?=
 =?utf-8?Q?nuReCzC/OdBXjRbonol1yfUXBdEmJ54AsqjBwBfIGU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <546A9234970DA54AA6B0556D38880136@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7068f6f-f2a3-42d9-ca11-08d9eb2938db
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 17:34:12.8813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CDQwkX3x/i5FZHNXl9ipgNWKLKBiVDzrkb/SUrhE6gElbPPjLwzTMyAAuUXWTp1l6coLAeT2wnkcnbojhAO0VZ/MzF0Ib0ba+SovPOXHPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1353
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080104
X-Proofpoint-GUID: YTeMUA4rcdctmaVAVE4WvcdSVAop26ZP
X-Proofpoint-ORIG-GUID: YTeMUA4rcdctmaVAVE4WvcdSVAop26ZP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gRmViIDgsIDIwMjIsIGF0IDE6MzkgQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFw
QG1hcnZlbGwuY29tPg0KPiANCj4gVGhpcyBkb25lIHJvdXRpbmUgd2lsbCBkZWxldGUgdGhlIHRp
bWVyIGFuZCBjaGVjayBmb3IgaXQncyByZXR1cm4NCj4gdmFsdWUgYW5kIGFjY29yZGluZ2x5IGRl
Y3JlYXNlIHRoZSByZWZlcmVuY2UgY291bnQuDQo+IA0KPiBGaXhlczogMzFlNmNkYmUwZWFlICgi
c2NzaTogcWxhMnh4eDogSW1wbGVtZW50IHJlZiBjb3VudCBmb3IgU1JCIikNCj4gU2lnbmVkLW9m
Zi1ieTogU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFwQG1hcnZlbGwuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KDQpGWUnigKYgIFlvdSBz
aG91bGQgYWRkIA0KDQpSZXBvcnRlZC1ieTogRXdhbiBNaWxuZSA8ZW1pbG5lQHJlZGhhdC5jb20+
DQoNCj4gLS0tDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgfCAxNyArKysrKysr
KysrKysrKysrLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMg
Yi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9jYi5jDQo+IGluZGV4IDdkZDgyMjE0ZDU5Zi4u
NWUzZWUxZjdiNDNjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9j
Yi5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMNCj4gQEAgLTI1NjAs
NiArMjU2MCwyMCBAQCBxbGEyNHh4X3RtX2lvY2Ioc3JiX3QgKnNwLCBzdHJ1Y3QgdHNrX21nbXRf
ZW50cnkgKnRzaykNCj4gCX0NCj4gfQ0KPiANCj4gK3N0YXRpYyB2b2lkDQo+ICtxbGEyeDAwX2Fz
eW5jX2RvbmUoc3RydWN0IHNyYiAqc3AsIGludCByZXMpDQo+ICt7DQo+ICsJaWYgKGRlbF90aW1l
cigmc3AtPnUuaW9jYl9jbWQudGltZXIpKSB7DQo+ICsJCS8qDQo+ICsJCSAqIFN1Y2Nlc3NmdWxs
eSBjYW5jZWxsZWQgdGhlIHRpbWVvdXQgaGFuZGxlcg0KPiArCQkgKiByZWY6IFRNUg0KPiArCQkg
Ki8NCj4gKwkJaWYgKGtyZWZfcHV0KCZzcC0+Y21kX2tyZWYsIHFsYTJ4MDBfc3BfcmVsZWFzZSkp
DQo+ICsJCQlyZXR1cm47DQo+ICsJfQ0KPiArCXNwLT5hc3luY19kb25lKHNwLCByZXMpOw0KPiAr
fQ0KPiArDQo+IHZvaWQNCj4gcWxhMngwMF9zcF9yZWxlYXNlKHN0cnVjdCBrcmVmICprcmVmKQ0K
PiB7DQo+IEBAIC0yNTczLDcgKzI1ODcsOCBAQCBxbGEyeDAwX2luaXRfYXN5bmNfc3Aoc3JiX3Qg
KnNwLCB1bnNpZ25lZCBsb25nIHRtbywNCj4gCQkgICAgIHZvaWQgKCpkb25lKShzdHJ1Y3Qgc3Ji
ICpzcCwgaW50IHJlcykpDQo+IHsNCj4gCXRpbWVyX3NldHVwKCZzcC0+dS5pb2NiX2NtZC50aW1l
ciwgcWxhMngwMF9zcF90aW1lb3V0LCAwKTsNCj4gLQlzcC0+ZG9uZSA9IGRvbmU7DQo+ICsJc3At
PmRvbmUgPSBxbGEyeDAwX2FzeW5jX2RvbmU7DQo+ICsJc3AtPmFzeW5jX2RvbmUgPSBkb25lOw0K
PiAJc3AtPmZyZWUgPSBxbGEyeDAwX3NwX2ZyZWU7DQo+IAlzcC0+dS5pb2NiX2NtZC50aW1lb3V0
ID0gcWxhMngwMF9hc3luY19pb2NiX3RpbWVvdXQ7DQo+IAlzcC0+dS5pb2NiX2NtZC50aW1lci5l
eHBpcmVzID0gamlmZmllcyArIHRtbyAqIEhaOw0KPiAtLSANCj4gMi4yMy4xDQo+IA0KDQpMb29r
cyBHb29kLiANCg0KUmV2aWV3ZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhpbWFuc2h1Lm1hZGhh
bmlAb3JhY2xlLmNvbT4NCg0KLS0NCkhpbWFuc2h1IE1hZGhhbmkJIE9yYWNsZSBMaW51eCBFbmdp
bmVlcmluZw0KDQo=
