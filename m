Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301D83FC7
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715045295; cv=fail; b=JVctx8OgtY/oxGD8s6Gw/VzZXTNJihf7WZAi9XlgtML4JkJdvRTUoL+SDWb/qR2nxYp41DkUfAbpVi4TO4Mkh/UyMIKYyiTXJ/idX9dMlvdTxX9Ftna8fmXEQucMfEmtJrvojTaoOFtg4BtSy+ynCmLShWqKJPCt9TzXSqdpjwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715045295; c=relaxed/simple;
	bh=hVbnEN1JzSkOX+4EkdfslwJ0LmBcPsrswwD8xHfqwhY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=j1IOBwMmZycgfU1sx82rUSQ7zx91cVnDBSgD2TxfMtxKU+s974fRgzziHMWva03TladJ93mIrA10R5F2G7BWw5SDxejFGBFgAMGWpwltkheLrbRvSW+bdeTZMJN1n5/fgPwnTiFllxS/tVXecNb4I32AR8rP+s1Zkh9WSr+i+Ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mhnJAlIx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yQoN9SKM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mhnJAlIx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yQoN9SKM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MmiFF018431;
	Tue, 7 May 2024 01:28:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=nhCOEuYJf+yyrsiMiJiHiQk0ZnNu58xodjvTU3WUkr0=;
 b=mhnJAlIx4kSXDwJbYI60IQPgM0lk8LfgcTnPHv139mMMJ9ovo/SDMJfz+Jr6Eo9/dWOP
 8ia1kXn8EHZnxGADdHa+IkFGilF69D+PPzW/XH4GuBbEJNV/deNz3jBen6Cx3ejc7bGH
 nZsZDMfqSsHwtBK6PNtVXrTWHQSf6yRNPJKaodMU92M3d8HffIsAtrYq2Q8Vf3b6KxKx
 ma54i0OaGIw1ZP6GysO+gVSkd/SPFrJhLrTprPVCVSR9kHQin6R6xYeBkTdlqk1e3ZsT
 rh1liXMKhro11COfXrKz1Tjooh2RpmQXrzrMr9blIKTZ8Z1ZPkdRV1rw68qjs8ij6wKE dQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwd2duux3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:28:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446Nb3GM027542;
	Tue, 7 May 2024 01:28:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfdkr65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:28:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3gHZpwCXIOGhsSx9bF3Lp9yfwckxTwuFinW/L/acc9cEkJnUDxFFURSaQO4LifbrRgYDqrww1BVt7YcP13pIaP0HV0+I9zYz+KD7XbFlZDVqfwS+r69D9hlqMs+T28eZPQDVyu/UwuX1cMmmaXqpP1YnX3/rhjlR0WP2ql7821KIyGR5CthKWj7yLmS+cr8K5asDiXh9X/AX13QTaspgC4JDpNMBsnS11ldp/w7i+T0BkCVtyFNJZWxPtI3y7UDpJAQgdGufEvcXvgVOqQR+R8rhu7EA2azFVapClUwtEt3myqDYem3ohlAEY/PPn3jNXLebD8jqFfCDWlfyD2q7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhCOEuYJf+yyrsiMiJiHiQk0ZnNu58xodjvTU3WUkr0=;
 b=eafRj5PL4TNtrGb/ugSS3s1AvFFSG7ktY61hKAMRC8djfyLbErpupZraZgNhCxrtgntr9z40BSpXbL2Q9ity0j9Q3uXYas9tzB3Y76gbtN/7kPn8BmQ4CrxgWW8H8lZY+3BVSH85R7gPfW0OFY4NVujF84ya+7v2U7/Qe6vz/Zk8AJEMTYcCWrcYCJA40DUe0J0HYOQNolFhEmxTPB96iy8AdEHfDP9+6AI7LOrIw/3drRXDOQY0kZGkflBzSvrZ0wdMmFNmT+mdJXk3YKbt1qJr0RLyJ3QUUBDq8pdsZZhh7A9ERCVU0NCR2/Oh/ziR5dXDd5gyCxJQjjLYbMlc7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhCOEuYJf+yyrsiMiJiHiQk0ZnNu58xodjvTU3WUkr0=;
 b=yQoN9SKMaWbbxV5+yePb/I40L+qsH+BqZtCvEkaG7O4+hJQM0TQZzeA2IBfbgNLmZbYUvzVcF6CyNIDD3z7zGmefdgwGtsiCtENcjQopqrVdZSUy/cN99tc95oVRIHVSTLtdgo1TLSZVDS+l3kcHypuV7Fi/kugsYughxt1by7Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4583.namprd10.prod.outlook.com (2603:10b6:510:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 01:28:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 01:28:08 +0000
To: himanshu.madhani@oracle.com
Cc: GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Fix debugfs output for fw_resource_count
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240426020056.3639406-1-himanshu.madhani@oracle.com> (himanshu
	madhani's message of "Fri, 26 Apr 2024 02:00:56 +0000")
Organization: Oracle Corporation
Message-ID: <yq1ttjaxvfy.fsf@ca-mkp.ca.oracle.com>
References: <20240426020056.3639406-1-himanshu.madhani@oracle.com>
Date: Mon, 06 May 2024 21:28:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0357.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4583:EE_
X-MS-Office365-Filtering-Correlation-Id: c4475484-92c6-4373-3ace-08dc6e34f3b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?2WCUgRKJzcId1wJ7gFdyuWMMAE+7lJKknGWTRzwhR4LFHDaaGRlJWglg4UT2?=
 =?us-ascii?Q?InyJsgLxroJQbpNjTmQyEI1J/4lGoFqgLSwFx6XpaSg1VNwUdDhIHgZrLdwH?=
 =?us-ascii?Q?SJprg6rSlwAdGXZsnK4VZfbziadb2YwNtDhm9Jjf7ytgExYS7iE49d8wbNJ2?=
 =?us-ascii?Q?jZxInk6OJcffVWFx65BCOlEKiWpW3FN6naHCitSuU1AIZ/KA4Z9XI20bGgrb?=
 =?us-ascii?Q?KA+WbNcvCqwzng6x9zDKFkbuRUe1IidB/H8bWpFWstR0q62kLf9UkHt4cu6R?=
 =?us-ascii?Q?FdqtU/yPUC05gjG97xsodsNX+Gxn/0Tu1Hy8xv8KjMepvnvdJysXRXEx/A6a?=
 =?us-ascii?Q?FioVHZwTb1uZrfXY/A0L00ADm+uC1Gi66+FmObBqGnsX9Zr8SODkZB4XOZkg?=
 =?us-ascii?Q?gVVCOlQn2Wjd+iUCL9gqX27BAuGLRTIDy4/fa9m5Xn53+qJlSq2/k3jbIvOH?=
 =?us-ascii?Q?D4o70qOrzeA4WHHiOruahP+VTKW5ljTjdekIVcKSjyMgtZIwTX/RyTmW/0np?=
 =?us-ascii?Q?vZRS/W1U4Yiko5BlbJ9peHyCdjIbD6E7sXWBoLfnetYGM8i1X3XS5qqSLjUf?=
 =?us-ascii?Q?mzUFGLO/RpOINtJsZlgZwIFbJZBlRYFIDfXNAG6vnauZxP+Hp+CDMjXBhZ65?=
 =?us-ascii?Q?m0BueTDfGt84ZmBAxCj7igQnpVPdNHO/N3/4B6mFddbfhX9q/iz3a2BGzJs3?=
 =?us-ascii?Q?5b0aXcs67i+aL7WWPh3kcqDRy9T6ST5UsmjhEzqYFnfqk0p2wxWp9Oty8qGq?=
 =?us-ascii?Q?2gefKTXKzE5xcevyAhazd1iyGYRHlgXzDYkQNy4MK6AIqfD+Ah3qEy8Tnn0x?=
 =?us-ascii?Q?dXc1xrUB6FeFxF/bncbTKd9lKpgpw/56hGp0SIMoiVVeJR+QAOHDi4oblSBn?=
 =?us-ascii?Q?QgOtTvqefF6dyHQBOPwqB1jsu0mfBw7R4n/+V5g+ue/GWfvH5n05IPkHYcxe?=
 =?us-ascii?Q?XRa8OmdgYP8gGySo/ff9nw2sZJnUcFONiw+8mp6Q6Ir9YOtZnnEsxpgiosT8?=
 =?us-ascii?Q?6kwROSexmH8g2W/gz1hZKZb84sUwU9DEaXTp3gbFeESaGLYNZl3tCmy8uiOn?=
 =?us-ascii?Q?PebxnbsGg8Ju0ubNVeOvXoy2bmd1CxQIyWMuvB//PMKCf5bPFXrkoHJuwfWP?=
 =?us-ascii?Q?GC5Otx98Idh7sYTURSuEd/MqlcJ7NrVj/O11Es1ItitMXSSurMnT56B7n8NL?=
 =?us-ascii?Q?96iXgFBcExcNMsX3L/hD189P7JVAVUaoxRtTCi6N9Yu26A6INTUSJCnNXVb7?=
 =?us-ascii?Q?VXC9dhF7G3z6sOv0MZ6FIvCaInyg1vmenHrnbEup/w=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?97HXl4YeWMHKUOiumWuV3S8mzXI+KHMPyqP4Y5SJNoiexZpGvSeaE+DuD4+u?=
 =?us-ascii?Q?rPc8T8D/gs/fLpp1uPrEMSjKgaziCZ6etV0l2C7ncGa+KUnjmR9bgbCvkpxL?=
 =?us-ascii?Q?qePsHjxmmyG38TcP9Lysu2CHywZc3LfOQHi/F5ornKZYT2S5L3ul3H8QCMkG?=
 =?us-ascii?Q?4VcjR8gLl0c8jiT6c7hNoe651uky8uSrLV3DaYke7EALsMdqmtv3oe1WkGSS?=
 =?us-ascii?Q?CT7lTXFKzApSJPe2sSR1Po8hSJkg7QMoiEKSqMxxiXTzqBeDQYwmwpngijXC?=
 =?us-ascii?Q?J+xYoYxZlY4qtnv6tyZlyShEzPwk6RA/x/b1bn8vwLT4tr4QfhRDdxaJrgxQ?=
 =?us-ascii?Q?ePUImCO435s0ThU8szXjQWcOStFasxXV0JLCxeXfhMiAgbaYpCkxoaJgUmfD?=
 =?us-ascii?Q?9xw7kywjiO3G9Zddil1UfhxvPM9GPHhWU69CiszC8tFDQn6+rsj6E8cWBGNB?=
 =?us-ascii?Q?CRubB7NLYfvlSC5PThHXuVzE6VPfui1I2Zs1pP7pFdZ9agOXyAeYVaz7NEzP?=
 =?us-ascii?Q?fRD31l+/TjsQSeNbEPsJS+PkUoKHZigN1iLMsirkwZdC/gP2F3LgTVXh6MxK?=
 =?us-ascii?Q?ZasCQOo6IqVwqNLGknSTipFlRfUCL38aVbQyQWVb2vEMICHvOklqEZSIOQdO?=
 =?us-ascii?Q?W6gaRwCipmWqiMj3VsqAaQNJIyZzXFdorjfjwJdBMYVq4wG2oBJmWu/m3NRV?=
 =?us-ascii?Q?yRG3uzkfEBeG2fEMOHKuJ6xrTljw0Fs07w2j909nio5PT2ev6Vls44fvfp2A?=
 =?us-ascii?Q?O+DqNyEVep8H5Yq1+kNJRHAhKkBvee+ItKOJt/V7UjX9bTsbpzrB/8I5zcLJ?=
 =?us-ascii?Q?tN0pVa1KkfT+OcOCEqKNgz95b/x52fy3qxYvRq47yXCLz27TqzgvYxA1ugLe?=
 =?us-ascii?Q?7hujUlnR+vnghNDxgHgoaivEN8ZaqnDLxTGvuNOxW28K3hQLOnwRrUt1v//K?=
 =?us-ascii?Q?7dWWZh7oaqf/GvGHfNRXNkNrknZqeSuWUiOA2+4eFGWgcKoVJmcLktGPz7oM?=
 =?us-ascii?Q?QdOHf/u2YcQV99ecMpe7aPFOHID0rG7JXxK1EjN7NUteMrMMB7w0z3TrUZdq?=
 =?us-ascii?Q?VaQeHmJ6O02SufAoXT2e8DqDqRilgVESqofjCLqBoIKiqp2WvtTEgb10S6bN?=
 =?us-ascii?Q?AGwW8O5YNmGUJ9+ABSyLKu2pjB0iOXOs61Jsm3kbZO6aPx12w+jHba0dph6x?=
 =?us-ascii?Q?7exGeb/B2FW2dRVT8f8c4KbY/d9kbqRt6f5zf8OqZlZWQgxaeuQnYtbvtaew?=
 =?us-ascii?Q?zy5LfJSaMwXy3fwGCSIeITE6xnbXl5cKURVKFXIwEyjsKgTCjbFEkx2TTcSX?=
 =?us-ascii?Q?e+vi8/apjeFP9gSHRqxmywr39420tIYE9TI5lR/fAnWYKtSTLkTsrfh4paya?=
 =?us-ascii?Q?MBvZSaDx8PJLK1chEim4R7QrclcGA/1GEJZnATqHieiv7rpTO38clcQy2Nxt?=
 =?us-ascii?Q?nleDQZXvZnTIxkFnXwQwRJ2fq7tlHXjEysTddzDou92pEAWZZIfW+sEfXkuW?=
 =?us-ascii?Q?CdJDWmXO4Ikr9neeIwHCV/SB3M+kQQwmL6ha3bNQwrIzgqEOCwfK9l1LZUB6?=
 =?us-ascii?Q?PC4NT/tToTrKsSIBYsFYyorzK+AeaCpn7lZflE5DZ13o+A9R+uRgbWk3lrU1?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	r/+Vi00nRB0cXHDnEUGRY9rsMeJ6/INAU2OAwMu2yWyzxkP1a7fN1uOzPifGEti5w3uCUPWe10dAorFwsspzoA9dJ/asW/mf+YlHlYwtQY5eBVQQVoi3UPG4YsQfbAOio/F2LymrneavI3LpEQ9TFaXGk5IICFnqPcRmR/277ePAF6LbqIMmSA/v5++VmIA8R+1th4oJEjvYhu8GNcRRYbE1Pyjr0j95mr52Lpkp3GsXU6x6IkG0+MHib/TLla9TOeVrN4vT6qkkX8risEA8EIEeqBQ+EcN5DNCOmC5DetTzKpve+iYhrlXBNE0PgUfAO41GK+FgOtaV6W2/qC7i/F6/RjMJkbz1/M8ihvYcnO2vH7IdvJ+0feUIUYG/XFRfliX/pO8Yke7XBVTFrpk6W3XVa/HIesU2cbfpagOl1TSx7r9LWFDet9DfNj0e9wTq371jAK6kHOEeFW2sXMqOKf4HjXGyyrM7S0uc/RQ++8yag9Nig4axlV9poVPmltwn5JGoQ3DGC4hsYe2yV5Q1MH51fcmjs+4hccZ1Sdjh6kZAtQA3YxWmS6ObqTERfPCkavISAsdvr8865ER0JNUBjfDgR9t3qnMTa73KJS7I/AI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4475484-92c6-4373-3ace-08dc6e34f3b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 01:28:08.6779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3yjrdfyLcNj5NSXe9x2dI3iAFNC4ghLewHVLOZ5VB6H2LSU68Kk3I3jOcrHQwDhoAYaNXk4oSO0dr6GhgpRJnZ2qODg/tg2AndVWo8ISW/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4583
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=900 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405070009
X-Proofpoint-GUID: MjSXPF5gOBkSz9Ulm2PuSsfYVH-sL_Kj
X-Proofpoint-ORIG-GUID: MjSXPF5gOBkSz9Ulm2PuSsfYVH-sL_Kj


Himanshu,

> DebugFS output for fw_resource_count shows:
>
> estimate exchange used[0] high water limit [1945] n        estimate iocb2 used [0] high water limit [5141]
>         estimate exchange2 used[0] high water limit [1945]
>
> Which shows incorrect display due to missing newline in seq_print().

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
