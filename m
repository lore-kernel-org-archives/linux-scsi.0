Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D2F125D0
	for <linux-scsi@vger.kernel.org>; Sat, 24 Jan 2026 02:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769223213; cv=fail; b=MYjCLuC4OIwQb1ZK2GryOkZV4caKxL/br+zN7VQOQQv+f6SVv7tozegHIESXxfwRFMzG/q8xrZ4Rdg7xtJLRA6/f2dOf3PdjXXz0EeHQXgExEO1arqZRl5pzeYRWG7xRbWImqxP+BwOyXf80zTFU2+0IvJ25KwUgt1VNTAQR910=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769223213; c=relaxed/simple;
	bh=7KCQIR+et5qbwLYsw1/Yc5+/IbQdQs/ykflnPV9zhlY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=E6lXO7Fu4ZqTU/+K5rpS0/cYrI3y7OdN+0J9CFmXCvbNp6H09qMt2Ev1BBkjer//F1HKORP/fcVKACov1ccA3rfngx4yo1aRamTNQ6Dlvkl/mfqWMeOvAquO2c6RuuzvY5B8LwLNYk3FTTWsTTeQYZonD+GrbwvUvGv5uFC9imw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GAI/HuRu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qG1O5edf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GAI/HuRu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qG1O5edf"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NF7eUo2973460;
	Sat, 24 Jan 2026 02:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=J5txzG3ZGmNIOaLLN+
	Mvmdh8gOtQ1XKVodMacisd+b4=; b=GAI/HuRuh0uVr3c2kMp/mTGON7SOrkaD8Z
	tJb9PImgk7DeP3DZe7WKXHB/UHSyStR3+6i6tx8S283WaV3ROovedi6KIJDGIuk/
	kPZ6q1La4mcvfY9tq6u06Ja7c0xheVe8Wpe9E2E5PSzwbxt9npDLNHqHPeoqwWln
	42vxn+Pxafu4hEgyS0mwJbZ6WCxbwceoWhJk65W6vfQNW0wrJ/xIr8xLv9BFvv6q
	w3URBq/NXJuPEf3DqXx2lJXwSBEe+h3lPTJKTbDaPzuB/ZQKa2lZVp7Dcs3Ku2tJ
	98n+qsBk01dwYEMUs79tZVXtuaJ068ZE1F7U4Gg6TYKTZCzpAcGA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd024m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 02:53:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1XfsG033649;
	Sat, 24 Jan 2026 02:53:25 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013004.outbound.protection.outlook.com [40.93.196.4])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh61dj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 02:53:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHs54iDhqJMeFSjAyjR2jNd11U2GynFnigJG1AmiY7n4HKHMcCoikczNV8wWuoK0OV3/VZQaCdNdla3LA0HEIohWDAaXz2pYwj83WOK3Eo58XuCfA7oLzOxMKas8hBYdyaVOCyCbjAoTSBk44KS5AfPfTXNvLJk8/Aal2WISPrjtNnX0Cjd4DOmNUX/iRZq598VtmVrccbLuIN8wKihhqJk+eRwPDquWIymt1JQtyzHVK9ej+2Cnq2vfOtm0FTK7NpJgboVYU7UyVhF7t+yS7I99vu1KRhEar51NRvhA/LYunWWwkHt8AuNZuSLjsaOsG03JnPDtdEhHudbhCf9zHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5txzG3ZGmNIOaLLN+Mvmdh8gOtQ1XKVodMacisd+b4=;
 b=JyeFEe6Oayf+xE3Cfitfwl/pDzCmGhJ8YA0uymqTwPtXneAWii8Ce+ArUL+0E5e9rVwt8vBooxEaBinIkdOrp9VItzGlQNbyIAaIB6t/ptU8Tcx/aeJ/sZJqHhJSrT+4CuACZYzSQfdv+aVQEDzDOKTGQhkpugug+5HfabNi5+XWz2i00IG/V3cIsmShAP7JAtvTPq4JDzFh1IGLIvxCehwovQ1hEbZu25h04Nx7YxQeDuhb2rM4ImsIuqOqO54yqsnCvpuOFHhxeJ5IQ+wGj2qR0/c1jcHOK44iA+hd2K88AERx1vly9T1HXVmlrPXeCU9koADqPApgiNI8HHlxnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5txzG3ZGmNIOaLLN+Mvmdh8gOtQ1XKVodMacisd+b4=;
 b=qG1O5edf5iii5bNZfEEaMnFRuK9s2Ed+8PTqLJwW6S2C3io341GdnPk6LArOmNZPD/HQW3p1iAyehmWPBLwqmkCW8e3H5y3wI/zTUxfEJKkvmSYY9Q7MBoCj6+TZ52ciQiecPYCduXBiPWxY7ck+Ijnardv8bbWsckuXiRP7hOQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB5065.namprd10.prod.outlook.com (2603:10b6:610:c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Sat, 24 Jan
 2026 02:53:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 02:53:06 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/5] Change the return type of the .queuecommand()
 callback
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <03cfe069-fa2d-42c9-bb29-5bbee63f3e6e@acm.org> (Bart Van Assche's
	message of "Tue, 20 Jan 2026 10:00:21 -0800")
Organization: Oracle Corporation
Message-ID: <yq1v7gryb7t.fsf@ca-mkp.ca.oracle.com>
References: <20260115210357.2501991-1-bvanassche@acm.org>
	<yq1ecnoj1wr.fsf@ca-mkp.ca.oracle.com>
	<03cfe069-fa2d-42c9-bb29-5bbee63f3e6e@acm.org>
Date: Fri, 23 Jan 2026 21:53:04 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0336.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB5065:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a684c2e-ccef-4767-3feb-08de5af3b2e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OUjscqT8Iqj5hj3XquDqeQilu0Q1hIK5+dycElob+rVtI6EVZNijqq++5v8P?=
 =?us-ascii?Q?Y85g/wE5a2I0QcFiZLclURV1+B7Js3X7I8ifgq77+7GVjlndDPq84+h4CpHM?=
 =?us-ascii?Q?LG85POtSsCN+FdAPZkkOScEiQFaagP92T71dVObR7aky9AUGHFM0XRvi8sF5?=
 =?us-ascii?Q?b3FwrCb3JbCFvl0jejgJAiUAty8XWwlMjWedovHHVhDgqLOeFI3f7vPASLZg?=
 =?us-ascii?Q?wb8VCutUFOI/HLTWvVZLYInE9v3/nHp/uL5I7iVtRFNns2bnknqyUk7ypgpi?=
 =?us-ascii?Q?lzn9FF9CkH8KXK2tSikK37rx1YF0SLY5N/DQhXPxCC0MjuyoiwfbozzKTukL?=
 =?us-ascii?Q?RU8vGxKc0+JSTUticcbH9sieXcAX6A1VthwlZb78uujMOXtPmo47AG9L3k3Z?=
 =?us-ascii?Q?vvDlnd4WwH4wJQ1hdBp/Z01rtf35bbZrUSEfYchtvjZ2d8EeJvaHjiaKjLRU?=
 =?us-ascii?Q?wsJUxZ7vT037rftTKtoWf/ST1qnUbsaTwy9nBcDo4GkyHVdcEa50q31lQU+K?=
 =?us-ascii?Q?K/aWZFd34B6KzsK3A7ZwkTJWLiufa2EjonC3Kg/DmuGzGYp24awN7MXTe3m8?=
 =?us-ascii?Q?OhvMjUpyqi8yoh9NGqH56xqwpjoy6qKeDVL6yBhhQ0G2quXGZQo4BUfB1My+?=
 =?us-ascii?Q?jpBdK6MKdjNVhKfVFpceFOq2fF8AuRBw4h+VgfW59Fe9OGQTTkrDocShC1fO?=
 =?us-ascii?Q?yzaepaL4zxQNPJkt+CtKrbeQZA0YbkPq/5nCbZsYwAFHws3vMY76uhj/JAS5?=
 =?us-ascii?Q?7XmsuH9KXqKTq/41afB1A4vsY/LNdQZQO7YHw1T2GrXzPhXd+JnL2a1c++Q7?=
 =?us-ascii?Q?5Z7M2VmR0BHqmfVWyrA+t+VUoqk/ITyEsSPF4wyoo019t59Luz81w3mYXFMO?=
 =?us-ascii?Q?GJSNktRoGgrn8nb6BSNrkI3m5kPlstAZytGxYmojbxNVPqa2YOWUfzucnku7?=
 =?us-ascii?Q?38DN41u0kABEIKedYZKFEeUMx0lOAgAogBJHCRmK+RfklG7OXhNVN73musEB?=
 =?us-ascii?Q?OpjnV2XQxFrDDDQFLVXWCecN7meL69OjsqQIOdEyYpfQunQ8KNVF+l7gj7n3?=
 =?us-ascii?Q?cUf4S1BAel2FTY+yVAQqghLnpfJPj9EPq5Zu2982BC906aeR4sz5w+w6qOmw?=
 =?us-ascii?Q?gm66/RTetX9bTY2l1pb2DHdLZsuahFEKhYRUwfm1SR45O1CNP9aF7aFeqhYi?=
 =?us-ascii?Q?VorDafqJv6klxeVmdxFWySKLYE018a8dRy3K0vhBUphBSYILHvRvwCKYGWYM?=
 =?us-ascii?Q?Pk5lC8vbPgsnAToZq16XXm4nJ6VgXSwr0KYNNNHi/CWZJfosHt1Jud5CrVS/?=
 =?us-ascii?Q?+dOMA/GEm2EIqtXo7LQRsNZpTqe0C9uvmPVNnnoqH52gJDGZ2Zl5mQIEbm5s?=
 =?us-ascii?Q?h5ciCgS6uY4RIKS2qQbz5pqjVJrBxQRzFTxqkxfFFqM+X/s/2zVaveEDaERA?=
 =?us-ascii?Q?csdanJ8elcavlKfc/HKNB2ZIodkTa/XfLzzBYNPLnN2Z54817dGz0AaoSDi6?=
 =?us-ascii?Q?/jYuB+3K6tboUWy1eVjgl7GR48n3HuduM6A73na/L/Nb6qJGsSyOZbElhE2Z?=
 =?us-ascii?Q?KgB/PZq82o79z1vQENIulH0sHlbLMRVnCtDfSRhm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o6O9iUzKcLvmq0yYpTH15D57o0d1eklebge4e1z6p3/R5FGA8VrVZmn7wc5w?=
 =?us-ascii?Q?NhoR3n0skovHRb4+Xbvy6+636cErhedY3QwjrcLLsTZwI94BjqPcLcAHmAwh?=
 =?us-ascii?Q?gu93EGRitaMAn76YAy+UzdvUY0RIRAOXjFI53cDzYvSbWGm8DSKkMpQ9D7QX?=
 =?us-ascii?Q?NweLp6N94XDkzGuOqzdshZn3B9xetpp1zJ1qWVNCT8WMM9R8D0kWp9p8Q90g?=
 =?us-ascii?Q?uCozU6oRoQPFCBtfX/wOnIRmXzEv8SjAPXU4a1ieCSq9tN1xorf2A1P8ZUis?=
 =?us-ascii?Q?RWit17mTEXQllfba3RGhJ5o3OMk7WtthLaPzY0WfCz7UgYmyKk0NMGvUnkK8?=
 =?us-ascii?Q?RscKmpiO/RhmNBQwbDz58KuCgQUIWsAMZSsrcSS0Qauafbp/xSgneOEtjbSx?=
 =?us-ascii?Q?Qt65k/Bw8fASM1NFbgrUtmXMUT0IfAkQ1U3oYZRMQb7CnkGJvg7qYL/9H4J3?=
 =?us-ascii?Q?mQvpW82hL5rLZ5L8DYZSZpZY+fv6jbW3hF3V9o6xOXDXUyFAFLUJIjOL1IBq?=
 =?us-ascii?Q?CP8dPAUyANPKXVs+PUF0ozXbO/zY9n1/1MrzmRR5z2LfuctbGU2ASshNCTWv?=
 =?us-ascii?Q?36PGznDsTKR3f2hPhhoPaq3n8/aZD/0kBKibH+Qq5H+Qcyg+jvBBsPMe0KFo?=
 =?us-ascii?Q?uyLfaWWowgQ1j+Q0r5uh4zQw3TJzxXeE4JkJFXGFh111nk2TKEEqBFMnqQZw?=
 =?us-ascii?Q?JD8uYUKqd6PLRau3lVgdTEPHens2vMQx2ZmefNMY8SRJUEQBWQ3O/Ayl6JoM?=
 =?us-ascii?Q?nGreGHrh77GNJET5uKSNm/OpfMepGLvDllnfEdshbmN10atvD7YjIfRFInzE?=
 =?us-ascii?Q?MOgp8hJDJCtpYEd8XEy6PAJGgAqDiELZnF3vJrIcBt9KpO3fIs6WmWl32146?=
 =?us-ascii?Q?yBilYhPqA+OE5mQYexUjTa3+EcOqXD/1UNqG7isQ97Ohxm0ydbQpjHplCKwG?=
 =?us-ascii?Q?0PjbK5ipylnAu9PpLp3sH7WJOM6nNu7oJ9U6uC7OeS6FKjth2whR36iyyT8G?=
 =?us-ascii?Q?LQGsNEgFduMA6A63B7wJoxXdlA6QdGxDaC/n5U0tHzYB/LuD2ftGm30zSF4+?=
 =?us-ascii?Q?uvvjznJKi20rpA/b+7bN0r5R9QzxFLohTDhdAoFZDvNp6fl81rU5NLb2NqT6?=
 =?us-ascii?Q?hGfWo1uiG6hJJVmlX5EyXbBSXC3hkt6laCDcwYtYWewfrINsnZv3ipzs2GdV?=
 =?us-ascii?Q?QgHoM4VFQ6Ut7nhvMX2GB//mrmlY6FKXbNiF1AWwEfptwerNgElJ1RT3mR8j?=
 =?us-ascii?Q?gcTI8eBtbddAgRJyatcMuDgf1DcHDWIG8l9+VYWg35m+LItyNvpRaBQZQPpO?=
 =?us-ascii?Q?GGhwcEeUJ9Y7ZP/0HLu3lSbQP7Z1qLx428CiYgTcmF+Y1EoAZApIq6I01ZWx?=
 =?us-ascii?Q?YFpGBoVrpucY4sCAeMWGIn3djXMwMKOJSCBdAqGVAtlpCHRUJ43C2VJJ20kI?=
 =?us-ascii?Q?3K7FBCBXO86P84g/AYI/O5ip43ymymEQyg0z0lmEJSNZVlqykrRypuZXpoQa?=
 =?us-ascii?Q?r3wsZpJ3ogc7whNVytOMbVvFaaBKU148OFFnfpI7BkBclE9xWyrInkLJKVUF?=
 =?us-ascii?Q?RRZmQUf2rGo+WQhxtHYXPKg4+B8wjF7X4MeDdChwEWcFaqWMgEHWDmyVyyOW?=
 =?us-ascii?Q?eLZFbMv/9FgoVMvU8ut6dkNG6sYlrY5wVhsDAFkl+atheLgcrRrIq+V/YUQy?=
 =?us-ascii?Q?i0LCYfQUOVi8Ufei8gG1NRlaRw88pO5/VBxTda8MzVIMjmqd33UlXGKelovA?=
 =?us-ascii?Q?zKdjBd/Mr5J0i//d3z6n/vqRSZ+jkik=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ed+1O3uPyMjCMgSUVz7f7WXpWIHeKlT2Aco9jyPOnVxHvdB+mZmHAmv49EVnl4GNadQdK7Mg+sCYvjVm+nRA/GkWq36wqnlILLoreYI+YX69AnQA+ZEmEOLHqugzMpg0Ds4KZIRH/Q35fmGsRNZ7xZphsHGXFflXy+2kE08ZQ6cRs3d9O+89UYh9e5HLiXz/B8cH17CflEKA63jCB8RT/iEy0wHFwGlj8DRphsO9wvDtdHW5oNwIxwBAUpBD8Mm9IySX1D99DtEhwd98FTZKEKqPNy3nzUkFGbsItAa05ZUhQflpMatTnFaeilMTIIgliUDmoamFhnHhZr3xUqk1ev9eZkwnrw+QuDCI7kEzIelNIpWLo2kMN6sWQzw44+fYSuk4A5YQFIUgNmlVV5ChetoVlfl+6ASs4i5o29K0bDpYZYjp/hoXLwX+fjCIzgcgprDWg4Ux078VsZpbcZ0UXabd8WfgcZ7tNLQ4KToIRlkRSGX5lo4KMLW2rTm0OdlulXZ2/qKTvVJBU+iPvAJ3kqAX79ovM8MudTMazNfWGxTPalGpu73RFzlO19wGwX6QV9wZ4cZySISsQ7MSOdYRkOc5AINTKM0357RPpbksM1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a684c2e-ccef-4767-3feb-08de5af3b2e2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 02:53:05.9929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkBApfy15+xqH+a9mvbrLLrM9Qgx82YVvpAKbXc44zX84VwRBeZ22cs+is8WOvesfWgunD6SMKLENP5AS9CzLFKFqYzNWsEKn7WBrUh8C6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5065
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=860
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240022
X-Proofpoint-ORIG-GUID: LpyeO_54-4FE8x_0mR60lqL-k1NynOT_
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69743426 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8
 a=U8PaH4sC6hll5cjMBW4A:9 a=pnI2m26_WTs5bHz79ivh:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyMSBTYWx0ZWRfXxeg8V0zbpVGL
 UwD5dzpQsWEnyrB0rT0s2oQJCsIw/X5/63mhA2M5uJSCpVw+RrMddhh7/8hNr6IpGe3luT8CajD
 7th9nFtbChCx/kpPfUw9eal4IKe6iiQP0SXQ8zxa8QvNL47SCzS+VB0gEJ7G7Znj+HqBJp7uiUG
 8e2kPfqX/27zATbcY+EbL16W8CIGQsRMrIyhA2hY7BxlU7vpN9+LbJJvXvFuAkIzZsdx4rKnRws
 OCFLcDEtE/1GCoBnX8b9Gu5iAURoDMcD5K3aEMP8mm92C6wGDl5W8RJ3nma2+1JmF4gW83ItiRa
 cNHsIZyC1plnlc/9gvvX/E3+o8F+97GyOsSje9kUOc0DwqWW2NEhd1crYWzY1U+Z6V7ylPeK7Gw
 0X5HkXdwXAeC9d6AB6Vk/d1dyWsFG9QSLr8iyBiUfcBCQEkEs6XcnkJi+kFbjf5dtI42UlHxaqN
 MeISX1a0s+9s0BFRzrA==
X-Proofpoint-GUID: LpyeO_54-4FE8x_0mR60lqL-k1NynOT_


Bart,

> Thanks for having reported this. Unfortunately I haven't been able to
> reproduce this build failure. My script for rebuilding all SCSI
> drivers builds the PCMCIA AHA152X driver fine for the x86-32
> architecture (https://github.com/bvanassche/build-scsi-drivers). Can
> you please share the kernel configuration file and the architecture
> for which the above build failure has been observed?

This turned out to be caused by an unfortunate quirk in how my scripts
pick the correct baseline when integrating a patch series.

Now applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
