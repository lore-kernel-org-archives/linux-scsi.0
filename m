Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F446AD58
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 01:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750813830; cv=fail; b=H79VNyc6r0iw1hpU4F4ANU9CkFakYoLHHVxF4MN+93sx/xlrhIH4LERfY4aQXhAUPvN5C5P96c9qzrX5J+6l3Hp1tuXha3uQoKoMAn24UYEWSCfVWZ+UTb2a+7113mBexYEd+cp2dgg3HRh9r583YtWh/klMYLhd3+DNXNdvQfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750813830; c=relaxed/simple;
	bh=0WJz3oXMLgQnfArbbSdSgJGdcTJukhBChr1W5j0Q/qc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=d0dDfqnCPsrhATQYKF17az8iIK+2NXIS7AsYe8xWOeK0ipB+OGIlD+VcCoo6vxd1YEYJS52lTJ/SDsxFh9z6qQVkjdiHEfoddpOONLR+0QitbxNZp6rn8QvVig2738SjlJfaC/NF1PeABzqvel9j2dnRAOoV0Noz9JT6YN50ZDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d/snOuJ3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vAcKl+fL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d/snOuJ3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vAcKl+fL"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OMihri002819;
	Wed, 25 Jun 2025 01:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+S2cGQxbWmxT++X96m
	NO8/TpFYr+TT/cITwtKIgSVho=; b=d/snOuJ38NjrAoGhscA97swaeqpY/dHfTo
	S0696zxvA+3FfddkglBl0xEBNWdcd9d/TJffwdEjKZniA2Ax5z1a/5ARFreVDS+S
	BkLxX4tG7XVOzUSuw0BdyMt0gOkvk62ROryHVO4r2G1Q465T6vnuh45YKOpOyPoV
	pabyhHrF6pVeEdoCK3o5gy5/E0NFOadvneUtqBI5pNE5ha6VwjD35IrLcvfv1ubI
	7hWwOLkjj/WMjO/Lrh6fHofOhXLf2ClI79UTuDxGxUvs09ZUGl6nKBqbpNobZApO
	q4WhCPK8PyzHMuNspRGpujLSXeYIixyVim4veFu6KU1WcwkT+CVw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt5n9fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:10:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55ONijsJ032006;
	Wed, 25 Jun 2025 01:10:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehpqvtm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:10:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R01Bgzh3JXlxh8Q5MuUiQA4qVfVTpYVIMV3Mhzs2s+LSNYPT4Fa3ul6qhddiWRUres1WZ0zEeuU7S8d2uyx4zK31GGc29vjKtAGMt2WHxSJ5oXnZhE9B4WrdgYGHwjW4L1ccHsg1RID2DMOYMcvISluK4VDwXArEN45fnOVIKefZZ0yqpHEdk1bVFiRjE/5E0LDQtmk/rs5jFwx0SfDK0ZcIvbYtkrWPq9uCh/NyG1c2tZVhU7X7syKiUix01bDfK0PRKj/vP/ajxSYp3043BzwItgZIG7yY4dOx5KCSITEFN6Rx0EEKYnC/gjHnNdqmGUF4/duOjxO/8ZOSaoWnWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+S2cGQxbWmxT++X96mNO8/TpFYr+TT/cITwtKIgSVho=;
 b=YFP2gEnA6zjVgHHGTO2eXx4r1rONlbYTv1K4QuWiNthPr6iA/1foyXfLKaiWgmgRCOJiKAhAhWR+r8IOCPq7uB/VtChcPbIGTwpQ06P57W5S1GnvAXwWqoKA89ns7vnYuQLgEnWbZvbr3covqLZI6sZOOs4PGG1zUIfK0qh7yWPslSEog2xSKUFqIFTM+SOM49VNES3b9gb5PlVPECbi4DvaEWVv0hupKvkAJQaEHNSy/iH5kbCyoDO2JImpxeck84XKkUHrrYYNgJ1rJDQXBP7PRdjjVD311ArMSJ41DOrlSr+3+lLGnnxbe4NHm2+SQWhRagImo2ySfUjFn5IJ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+S2cGQxbWmxT++X96mNO8/TpFYr+TT/cITwtKIgSVho=;
 b=vAcKl+fLVlSdd0O3cy5lg1CZm1J6ul/kqH6JL0T4G9Wa3j+6DWAZr+5zko87ZLFYDrHZhjUSpKTcZTQ7mdgvpKWmWs8Ol8meG+VwG0dK9UhUiT7HH3QzAFUo8XyZOAbyp9ElmYGF9ihlWTGakxUxusSWhhnzq1XX+p8g6ecLv8I=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4746.namprd10.prod.outlook.com (2603:10b6:806:11c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 25 Jun
 2025 01:10:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 01:10:15 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Ranjan Kumar
 <ranjan.kumar@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: mpi3mr: fix kernel-doc issues in mpi3mr_app.c
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250620162158.776795-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Fri, 20 Jun 2025 09:21:58 -0700")
Organization: Oracle Corporation
Message-ID: <yq1sejooccw.fsf@ca-mkp.ca.oracle.com>
References: <20250620162158.776795-1-rdunlap@infradead.org>
Date: Tue, 24 Jun 2025 21:10:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:33a::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4746:EE_
X-MS-Office365-Filtering-Correlation-Id: 94001adb-6c47-4418-2930-08ddb3850b11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dWWuLKN1Zk7+dM1oiB/GJrEcBTMOLzRVz+7/TJhOMjAD4ASjW9zOuqsGVMoA?=
 =?us-ascii?Q?kCwsRWdl6dGHKfIWWxQEk9ZGjnbQKNVOcHp7q7X+MRlV6+gjTssfYRSAvR87?=
 =?us-ascii?Q?4X3MaNm5pz9MQ/pXZcb1bVq/G4DK2+WOt1ExQ4R+s9K/br7vrsMYHhFlmaAO?=
 =?us-ascii?Q?G8+MPH3OOnyNqxcVyAwUaGbmTaeACbdmEU0I6MPZtSrCFS9C/+dG7azgAS46?=
 =?us-ascii?Q?MGYqEbV5XgelnYAOxoqXJ66JrG1/MQ4noeFqLoJBhMMEz9Rq0HSLy+AO1LW4?=
 =?us-ascii?Q?v+DvJUSlGKhG58gUN+GfmiS+wwds47sCgdEjfp86lgHQR481ngepNIHpkzhm?=
 =?us-ascii?Q?5s7G8ukiPreN3LwNxC1qrqvg9i3EiJJnBOqMSWJdDZ4PZyyMxSlMTJ1VHUcm?=
 =?us-ascii?Q?3mEr5P0TS+EJWOiqzwQtmnfTEGdtZmjgRWp6RhacXhQRN5JkzOHbJ4NcTqbh?=
 =?us-ascii?Q?9VZQ3nVUT5pAdH1t8hr/+iGgwk7ERcfe7w4vEUskhxnyzQ8FWd012RJwKAVQ?=
 =?us-ascii?Q?e0Uv8gSDUnbf49g5ptMfh9dP+H9rHojaoDYuv3T58z4aODvkKk0XOlsGWI+o?=
 =?us-ascii?Q?PLBKRelCVav4hLmFoK2XI82Hpe51YK5LGEXOzC+zg3w9PSl2X78PmcVO8u2x?=
 =?us-ascii?Q?RhzXDvc2ZK3jd+WEMcnsB5J/+AT2Is4RFx9QTTm0h1CUxlosb0Gjlf5H/a/9?=
 =?us-ascii?Q?srbE3bkFzXCBjHNadGzCPNS/va65r4w/rMdj7RHDC/eq86u7qYh1JEVvyeh7?=
 =?us-ascii?Q?8MfJTvlNsej51N8SBKhczvIMvCRLkt6Xs0FH/Jb547Zgt8KEi9ZIf5JAO0by?=
 =?us-ascii?Q?m3vyDgMI7lbCvtFjaPlIiUC2sY5QZ8re2yQk7KiDb0oE26cyx4D+UF45sT5T?=
 =?us-ascii?Q?RsX/yLgIeSldXB1EePg60y1lo5dcihs31oLioxkLt+GX6R7+ynkZEiV37HeF?=
 =?us-ascii?Q?IlMP8tOlCcxYWnzBtsIdz96fP9Z9W+8rm/WmLinfke+Rjm3uwxwKwqxd0QB3?=
 =?us-ascii?Q?jHGPjAtYXeeYm4QPjM/O9BtJFiEIUmYMVZZUBru3BkIUGl164RPdgf2tQyCs?=
 =?us-ascii?Q?u0yun0GrmoJIRMd+qJhbU/uIUn+XfXMgnKqt87t1IN5HsWH4047O3bL3bL3w?=
 =?us-ascii?Q?PhUPDu8wWggv4FeJCdT23Hw/v0UauqxfLJ0JTT0SEIj9m+jIK+tdYUr/Pcus?=
 =?us-ascii?Q?g4+2q66SJnD47sTX6f2xaWbeU9dfho4jU1eN70HJrVAsAIsUFSbI9OwlA+NE?=
 =?us-ascii?Q?M8j0aKvvwsnp07comearnkHQvye5Lzg9Sq/jkJazFjNpdlEl6oYMepjkGWuf?=
 =?us-ascii?Q?Dd6tnt5JXr/Zhe8zF3Afp0+B57mDGTuuSF5U7GrxpnjzEN4kG6PCJk1glsU+?=
 =?us-ascii?Q?HRoRYjX/3bLzHfDVU7jecqBIEPbkZQIcu8nd/smy0n/Fc4eyOvQnJn1DvMlc?=
 =?us-ascii?Q?//ICC6++Nv4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eeFjIm6OUvL7QWGJlG1IvtFjcQ2oNktYjviRVl/Xw85XmsW7P4pEH4ptX13+?=
 =?us-ascii?Q?kJrtaPQDh1LUvQ+bs6groKHNjMmXQDUaBlDYsmiCaR7wnWhWRsk/LM2GPT7E?=
 =?us-ascii?Q?hMALH6CtFdmb6DMjc/6AesEd0wtQEuGA+VeEpS5j9YcgxEu2YvOdeHsNG4tO?=
 =?us-ascii?Q?65HS10KIz/GzSCiLqLVs43kN6qopbYbTQ7c1XFpRlFYNQmtpfOsc1yD44pOP?=
 =?us-ascii?Q?BHBFFpQonh07DD72qIqjERVjkffCGQ7sewSX00fKzocw4ojiChvqdbXf1Et2?=
 =?us-ascii?Q?9QIS95qVzwCsahFJskiMbvU6iqxlrHaSsKFVoFXfVH5sy0obbkQMQpdWuITc?=
 =?us-ascii?Q?zhfjoRzcJVNhtB7/wJK9QLZa2agGXNBdlpJDYpVgsB+TjuvKz8g0jVFmoHJm?=
 =?us-ascii?Q?vJJQlkzmiG/XLuzv1D4D6q3MLC8ZwZaoCXywD7oiCw9d87PhwTl3kXBjLzA5?=
 =?us-ascii?Q?3TJsGgZWezkUMwLebVe9dtoxMVKIEGUhjn8aXLfwHRoEtBIf9Dno4OOROIr0?=
 =?us-ascii?Q?oWfH0B8/DITL8CtgVDy0VcvFFVVeQETFyDgVuIEHolFBXYN0yICFd5WEcgnR?=
 =?us-ascii?Q?oD+45T9pyODo4Qz7Y7N+aMGGMN77MPaWlxXjol0qh40ZYD9Byp62Gxjd+tOp?=
 =?us-ascii?Q?LBUNg9hGv5QnYg+3cSAJq4533Buje4/Y/08W4AxAMB/+1wok6kXcjx/2F6dG?=
 =?us-ascii?Q?DSFe35yEnav8QdvEJtDuYaEvH4U8q328rGU76+nyg4h2xHCICGDBmCamIgUT?=
 =?us-ascii?Q?FWQhzryWAwlg4Tx7x5v1EFtOqHJrtPgMFqIXHR/l3VwEO7MdNL/NJCs6xnQM?=
 =?us-ascii?Q?X6F42iohfb4xwERCFz+xhz8OGEeCXt98xUIvMu05k9JfCLDa5RX46wkDUm0t?=
 =?us-ascii?Q?ppMTF+x/TTMdVHDRFLaRYH+taEntSH/GZ4uLZsOz1FInyVIIVasIJFc8c9qm?=
 =?us-ascii?Q?2aZEj2tI4FgzZ4lJtn1UJx8TuqKQ6PRYe/H5P6Mzdvrndv+2rV8IZF4h4tPQ?=
 =?us-ascii?Q?U3JLfzKVAXpubyebf3px4O6KPW1l2YIF64sZLB4DYPTZHwcXTb4hJiCGxpZV?=
 =?us-ascii?Q?SVB4aJINiVg0h+omFT2y1npCEAMkXyn7wPC9hUZF157fzF29GWybjFe/klwf?=
 =?us-ascii?Q?Abp/Gpob9vxvIiPFwZAfVIWoG7cwJwubSU+QTlPbYBWChau6ZsHU+73SIZOF?=
 =?us-ascii?Q?esRJrzHVbc5OqC1/Rm+5dto9/dPFBoOKXVYmYQCePbYxHi+nXpxMNLlNxekT?=
 =?us-ascii?Q?GUdORuqbOEAnfIsvbWTtu2UJeXE0S3lHVIGL1v7XoI3GZ9VDXden+IAiZnH5?=
 =?us-ascii?Q?82l6qa13eT/QRrn3ZLOJcoVViOXyRibR7ir9rajld7Od0s1lFVDZsf4Fd+Bo?=
 =?us-ascii?Q?T3YRjfEUyvi234FN8t7Q00wVf0iZs5CpUGjPICZ5d1rHepy5b0pugvk/rD03?=
 =?us-ascii?Q?Gy1FVC35TGUTW6RaV4n+rYDAfHiRqH1lVVSarnu9vLGdTKAcUKjt/s4T8E1r?=
 =?us-ascii?Q?WNB6IW+lHUTMcTOOLi7RR97PfpRFAxNRvs8KLHtpiMKorc7NibMSKK1ppXiJ?=
 =?us-ascii?Q?vTyfPcKO2FO5pU7XDARoMNPMRRiMnEnx3dfnFoMSLpEWroOAa8WFHhZPVuE+?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F5ZZnOEzzqCibmMCszNBJIVaImcXsoRjBkVSbNRy/5POQFE0tXnsy+WM6iBMX/5SpMBnbLsZGejAOThfzm2IOCaVBTAjJBLf61nM0bDjt2bPx/BIkEGJ+8XmMKjxm3WZho4nbxGLNa2w6aJSg7hcMV2WT5t7Ytew3aIBWmQgJG6py5FBtQM8/uMV+2JuPNi3pmphb5IlF5J/CkzSs24U/KVWpzEskSORooZqJhI6q/2Ym+bBmCw5oUfCQ+SSCu1DtR7c6duiNMwYZCYDAiXiSnkPMncZoLCKTzxZP3AV+ZAGnZ+Jm+GkIhE2JPmONNP+uj9ZB97EZLJQMOfo4x0dR5jXEPZTQHnMsnb4146vVlYWi4TajhXBxtJlBPVpkuz50Qchm4AuCXDK3tjBEViBzvCnxGsquOzu6sB0QvkkeLpgH+w3n4tZQRMsxgUjbgxxKT0rWskqVKAAtuWXUr8UEtkShbkUtJmCFiysLWrvqK7j7mwf7vSCuhcwCCM7ARAkBRCgVZj6duks0QhNDynA8caAtiuuZzZVLXtww0E+UisV4NTcQdWb6jJ+VIsVhOz42sc+E0pT7FjaeW2zG8RKV2aZFVkGzDnU0skjfXI5Uzk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94001adb-6c47-4418-2930-08ddb3850b11
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 01:10:15.7728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPtteHzzVt9YGhvrbl6pwvB8EyNNpbyigKcJp6uIy7VmrTvzYsR4RM8za9lSwqQg91HEVLzMFf4dH99wiiLb/C/lBos800g4ScOH46K7ueI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=862
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506250008
X-Proofpoint-GUID: kIftG_lACkMCZFbsDDrlEJXXh2nduGSc
X-Authority-Analysis: v=2.4 cv=PMYP+eqC c=1 sm=1 tr=0 ts=685b4c7b cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=YSDClnwbtD96O98uur8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDAwNyBTYWx0ZWRfX2p/kLBahijfD NOa9rL5N/Tm214AdFX787DBu1BqhnBpojCfWu+pAy3Cv6vKB6Qlh1wjXeZO9lkZRrOUC7QfgE4T r8LW6EoLtapP8/P3fmJp317LX72gUEbcFLMKPQNQhMOlEUGAoYfIS6yjOh+uW7DfG6qQqWHiGvU
 hOS2peJfnnB0L+V9Heohe5oZgROHPpZuWPIBOsewctDZfnGdnwqNxDrEomciwljDFm9YE8pO9p4 cUNX2Xsi0UQOLwXJRqrmE82g3FQU/C9qg5HEHbhpmjtHUKMIV2E14j+GADiOrS84X9iAzz4KOFu y7QRuxKBLyJH9nVVoFcKKSjrci3aDmNmHSYQyZf6LHTrs5nY4ZYcVoMrFbpYestN+jkzfBrh6SS
 k+YRUuUkLazsGqyQ6xQ+e5AMbmGyk2V/7KcslFrjQLyy2ZQ6k4tsfZRP5mrBuAOiUaPwZXOy
X-Proofpoint-ORIG-GUID: kIftG_lACkMCZFbsDDrlEJXXh2nduGSc


Randy,

> Fix all kernel-doc problems in mpi3mr_app.c:

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
