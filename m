Received: from alln-iport-2.cisco.com (alln-iport-2.cisco.com [173.37.142.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C4C2D94A8
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 23:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762298330; cv=fail; b=LBIeK4uDxVvI0ZQ63dOk0D39t8TNt2tkqosYJSvLnGHte/4tt2RNB2CoU1ODdqvY9iXnN8ynYSeXHUh64uJc2eXnxIWlvaXRCn3/RhuF+LNnxhkw5lHTHbc2m46B3DAJFiTGHwnB3ji4egcn3EcBQsZNDjf8ENJfG9PCdzCp4XI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762298330; c=relaxed/simple;
	bh=8gfI0i86c0oLRzEaMWnWyTMmR6aT5uquNiOtvEXH1xs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LrmJ5z36HcQRskkgcm1nWMHY++/GlLoLoqRWfKUpXXkoi2ptN1+JFAINmAaHoYew269qFJniB6jpPVA7kUl/cRw+ForlMiGBect5I+3/eY/4FnfBM58b6mSCp4hJNT99AxhprdpsXPi1OS1rTkwa4PghGmhqJW7L8W1fvVoJrFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=RPJBlKpo; arc=fail smtp.client-ip=173.37.142.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="RPJBlKpo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1616; q=dns/txt;
  s=iport01; t=1762298328; x=1763507928;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cI/RRbhNCLoPjD2A0+uE41RWDyAVWn1UCrra1fC1zsY=;
  b=RPJBlKpo2CpCyYoX62hGVNNVOy++FpQGQRh2W158rVintd+v+jzKZvcG
   vC8frPyHwtup6RO0uO/qIx8n5wZj2ISozbS0CnjMjKjSPcH87Z4nlKlwD
   RgI4bclFKEwGBG2RCV1VTMfVl0vtISybhfd3c6YE1e/XvAbsjQgu/Kb+b
   XE37x3a7XePkftCsIdQu5jDkWZzuDYfigcFu084j7al2/39UcKf9LTnNz
   vdTq5jviOoTWBq4CaZlpJM8a50wSlB1V/MoP4+q8A39PDcy7YtfMy2dR6
   Sa6tGgd/kf6K9HyHv5bc5wJeL5N7u7C0Ycl4EOtnCPf7LkMtgZhOWIn51
   g==;
X-CSE-ConnectionGUID: YYbLsBZNQ8SI+kDbUpGt9A==
X-CSE-MsgGUID: XHQdpOPMTXKJ/6ivwQ+Xjg==
X-IPAS-Result: =?us-ascii?q?A0DqAwCbiApp/5UQJK1aHgEBCxIMZYEgC4FuUgeCG4hpA?=
 =?us-ascii?q?4UspxWBfw8BAQENAlEEAQGFBwKMVwImNAkOAQIEAQEBAQMCAwEBAQEBAQEBA?=
 =?us-ascii?q?QEBCwEBBQEBAQIBBwWBDhOGXIZbAgEDEmcQAgEIDjgxJQIEAQ0NGoVUAwECp?=
 =?us-ascii?q?z8BgUACiiuCLIEB4CaBSohTAYVuhHgnG4INgRVCgmg+hAo7hBOCLwSCIoEOh?=
 =?us-ascii?q?ieSb1J4HANZLAFVExcLBwWBIEMDgQsjDzwFLR2BJCIfGBFgVECDSRALBmgPB?=
 =?us-ascii?q?oESGUkCAgIFAkA6gWgGHAYfEgIDAQICOlcNgXcCAgSCGX6CDw+JdAMLbT03F?=
 =?us-ascii?q?BsFBIE1BZZYAYEOeoFFkzNdswsKhByiDReqa5kGIqh0AgQCBAUCEAEBBoFoP?=
 =?us-ascii?q?IFZcBWDI1EZD44tFs8TgTQCBwsBAQMJkWqBfQEB?=
IronPort-PHdr: A9a23:uCg7OxLOIO3J0Sr5J9mcuVQyDhhOgF28FhQe5pxijKpBbeH/uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:k6hvrKiaQ6ahKCy8flzEweqdX161KhEKZh0ujC45NGQN5FlHY01je
 htvWDvSOareMzD1KIp/O9nk/E5TsJODztRiHlNoq300ESpjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOOn9SUgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSOULOZ82QsaD9Nsvrf8EgHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUpy+xTGkt80
 8VIExFObTyJuvqZ3OOSH7wEasQLdKEHPasWvnVmiDWcBvE8TNWaGePB5MRT23E7gcUm8fT2P
 pVCL2ExKk2eJUQTaz/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKLIoDRFZkIxBfwS
 mTuz0TADgk9DPmj+RmntSytmPD23hP5V9dHfFG/3rsw6LGJ/UQXCRsLRR6gquK4olCxVsgZK
 EEO/Ccq668o+ySWosLVVhm8pjuA+xUbQdcVSrd84wCWwa2S6AGcboQZcgN8hBUdnJZebRQh1
 0SCmJXiAjkHjVFfYSj1Gmu8xd9qBRUoEA==
IronPort-HdrOrdr: A9a23:KdqYvK1YNGiNEqRyUAiLrAqjBfRxeYIsimQD101hICG9Lfbo9P
 xGzc566farslcssSkb6K690cm7LU819fZOkO8s1MSZLXjbUQyTXc9fBOrZsnLd8kLFh5RgPM
 tbAsxD4ZjLfCdHZKXBkUiF+rQbsaS6GcmT7I+0oQYOPGRXguNbnntE422gYzRLrXx9dOEE/e
 2nl7J6TlSbCBMqR/X+LEMoG8LEoNrGno/nZxkpOz4LgTPlsRqYrJTBP1y9xBkxbxNjqI1OzY
 HCqWPEz5Tml8v+5g7X1mfV4ZgTssDm0MF/CMuFjdVQAinwiy6zDb4RGIGqjXQQmqWC+VwqmN
 7Dr1MLJMJo8U7ceWmzvF/ExxTg6jAz8HXvoGXow0cL4PaJAQ7SOfAxwr6xQSGprXbIe+sMiZ
 6j6ljp86a/yymwxBgVqeK4DC2C3XDE0UbK2dRj/EC3F7FuKIO4aeckjR5o+FBqJlOh1Ggqfd
 Mefv309bJYd0iXYGveuXQqyNuwXm4rFhPDWUQavNeJugIm1kyR4nFojPD3pE1wv64VWt1B/a
 DJI65onLZBQosfar98Hv4IRY+yBnbWSRzBPWqOKRC/fZt3d07lutry+vE49euqcJsHwN87n4
 nASkpRsSo3d1j1AcOD0ZVX+lTGQXm7Xz7q1sZCjqIJ94HUVf7uK2mOWVoum8yvr7EWBdDaQe
 +6PNZMD/rqPQLVaM90Ns3FKu9vwFUlIbooU4wAKiezS+rwW/nXitA=
X-Talos-CUID: =?us-ascii?q?9a23=3A1b0CK2qnb4BXc7mn5Sr+stXmUfEUeFnG5kX2Gh+?=
 =?us-ascii?q?DKCVqZLeoUXCMqYoxxg=3D=3D?=
X-Talos-MUID: 9a23:PjY5ugXX3h3qG5Dq/A/MvT16E/9N35SNKgdTkIsZgoq0NyMlbg==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-12.cisco.com ([173.36.16.149])
  by alln-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Nov 2025 23:17:39 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-12.cisco.com (Postfix) with ESMTPS id BB30A18000156
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 23:17:39 +0000 (GMT)
X-CSE-ConnectionGUID: 8Kc6LG+FTumaRAc9cQjAdQ==
X-CSE-MsgGUID: ddAjA76wQxGtfO/DTajiWw==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,280,1754956800"; 
   d="scan'208";a="61220656"
Received: from mail-bn1pr07cu00300.outbound.protection.outlook.com (HELO BN1PR07CU003.outbound.protection.outlook.com) ([40.93.12.0])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Nov 2025 23:17:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r9WSVPfYlSKhWgp50rsVwfPMFpsBCJ+nNYWFgo/TGK7gZZuDhLFpa9e2zg/nN4RS7evsy0/2FBoGhsUgB7B1PVr71x7ifK77gWSQQVs6iiGccM50s1iIjFI8SQ7lqHAC537iNNAlpkNt4EhgJb2GOZ3ypQXxKjV2cY2+YwJMkzRFbGDBEIV4tgHX5fIbCnmawk+6rYNMSiumdsNZyx+SaniFQObhZUV6o91Wo5QBM+4DKfd6uZBTC8n91ENewap8QzqaqyVfxKmTNIltkObKMzvT6ghFzKU4jv9R557kbXFKZM2V1VEIcFY9F4cOY4cpmzg0oYlq67usGc9Jdw/NIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cI/RRbhNCLoPjD2A0+uE41RWDyAVWn1UCrra1fC1zsY=;
 b=nJm5aPlguBPUDgbZkgOlkwG1Y+Af0tUXE3ESiskW8QMhqZd6yDRRb6OTLLbgDowF+pCJuKzJNu7Efkl9W45ASID1yhRWKGLuGzKgx0NFxuhdhDp18Ja+fUHJXDqaOD+IY676tIzYZlpor5RQp4rd+pEaKgSigm5rdDuVKxUpXlivDDiNqnTgG4xJCXbhoMj8XysCfvvb2xkF/zlLcGhyNqDkEis4pllRuwBWGs7F7qUdeQBgNtARPP/5iRt40VfOkXavxSU/wfsQr2dxZd3QOUluqP/MUaLbzp+q0Rrvgvo1t4WJHkE0ga+HNkjZ1ZwRGAKjrWzSZm1VTEUhvueX7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DS0PR11MB6351.namprd11.prod.outlook.com (2603:10b6:8:cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 23:17:36 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 23:17:36 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>
Subject: RE: [PATCH 1/4] fnic: use resulting interrupt mode during
 configuration
Thread-Topic: [PATCH 1/4] fnic: use resulting interrupt mode during
 configuration
Thread-Index: AQHcTXJy7fGMryEGHEKw0bgU95oVpLTjJzaA
Date: Tue, 4 Nov 2025 23:17:36 +0000
Message-ID:
 <SJ0PR11MB5896352887666D1ED62CFEB0C3C4A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-2-hare@kernel.org>
In-Reply-To: <20251104100424.8215-2-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-04T23:16:30.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DS0PR11MB6351:EE_
x-ms-office365-filtering-correlation-id: 7162ec35-0c11-4f6d-94d9-08de1bf85784
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?ZmkyVTJKMUFQejI0OURVdHJFWVQ2N0pBcGZZanhxKy1HdEJiYzZ0QU55NWQ=?=
 =?utf-7?B?cistNHhaaG1wZExVZmM2QXFuL3VRZkJNeWZRL1h5U0JnOTFxMFhUai9MRlFT?=
 =?utf-7?B?bnhDd29EKy1tL3orLXUzV0VqTUpvRHBuKy1NNDNEVXFkbkpER2s5VHdpUUI0?=
 =?utf-7?B?ZUN3bXJVaXBneGkxMGV1ZFQ4YistY212UjAvMHBnbkNFVysta2FEOUxwTGlj?=
 =?utf-7?B?Z1pzTFZtMlRKRS81dDVEaVZGcGRzaGhhUHhSV1JTSUhCTFBjcnhnQld1RHdL?=
 =?utf-7?B?UjdnUkJOTlFZKy0wUWI1cmo4RTFkZkZUQkVET2xib0l2Y1E1RjM1L21HUyst?=
 =?utf-7?B?VkloQ1hObjM4VFZzdmREeHVtTHNjNzRnbEE2NlV2V01EVXlUZTFhUHY1cU4v?=
 =?utf-7?B?Sm9TdjVWWEFwb3kwTHhkdWp5RnJLdzhVWEhoMUM2WXZWb3JvQm1TbjZQUHZK?=
 =?utf-7?B?RDhrd1ZuNUd6ZUF3Skw3NEZoMkIwN3NqZHBreUxtT2ZSQkNUMnBZQkl2bUxr?=
 =?utf-7?B?NEQrLWtpcUcwWFdCam1CWFkxTjNYNDNKQUpLSktiQTh3cmM0bjFFeC90NFpH?=
 =?utf-7?B?TGtxR0Z1VnhabTZrZE4wLzhydEtYMDRqT3JiSTBCQnRRT05HZkhwdGxqWnV2?=
 =?utf-7?B?dmh2b1Y5VHROY0I2L3Jwc3dlMEJhbUQ4VkxJVnNydlFOQk1zdlVGWEl0cFRX?=
 =?utf-7?B?WVBLOFpJaU1qVFl2SUlaMTUwdUxLTEg4RTIrLU5iMEZKNTVVeVVmSmdpdnJH?=
 =?utf-7?B?TmJlTkl5VjVXV0NQUUdKS2hkNjBndW1xSndVMlhNaGVhQ3QrLTVrTW9HdU5T?=
 =?utf-7?B?NmxDT0VoRjRjbFhBRG9jeGJGSFpKVTFZZFM4bTFxWmh3V3Zxc2FGOWpQbDZN?=
 =?utf-7?B?L2hMQ1FVdDhzUXZFNnNHM3BhTE9PQnBJRmJORUR3cUNNRlVkMDZvTEtlaG1t?=
 =?utf-7?B?REk4UGl0ay9oVGtCcUV6VGpmY3FIeXZFeWlnZHdQblp3b3RhTE12WUlTZEpZ?=
 =?utf-7?B?RlNtKy16bnUrLTlnMWRoVEJ1RDRwdE91WDd4VVB3anpuWTlSU0plU0tsVTQ=?=
 =?utf-7?B?Ky1vb1BQN1JGZTZzTHZhc05LWXFpT2pzKy1xQ1FlNlErLUdDQUV4V0crLS9k?=
 =?utf-7?B?QXlZeDNkcE5UeWFiTlM4US9UL0RGRlplSW0yazBJVDk4TGpMdmJWcTI2ejV2?=
 =?utf-7?B?T1Rua3VJYUNIOVhtUzFkS0FDL28wdDF6d01wS3B2a25ET3laejRGNkVCbE5C?=
 =?utf-7?B?Z1YvR1RvVDV6Zk1LWkZ5d3d1cmhpVlROUmlRTmkyRS8vNVpQKy1QNVpxa2pN?=
 =?utf-7?B?SmhLMkpGQjkyOWVNZDVmYXhBbkxKbGNrRmpsS0FrT1FkM2xRREg1RG1scmI=?=
 =?utf-7?B?Ky05ZVFZNW8zRlRmajdwbmpBQmY1T2VpeDVhYmIrLUFDRU5lRk5xY2JRM29I?=
 =?utf-7?B?TDhyd1ZmNEgxMGlKeGJxWWsvN0hVcEs0UE53ME0xcHNPbmVKKy1KSmxlSklh?=
 =?utf-7?B?dG03bXR4VistRkFSN2hBeEpLbFcwTmdzeXQ1cVcwRWx6ekYza0VqcGpZMHVH?=
 =?utf-7?B?dmpGV2svM0dzUUVZWXZ2ak5wNHVoL0U4RmJ6Vm0wN0dRcnVXZTVTMkNlaHNN?=
 =?utf-7?B?MlVGdG9mdTh1a21vd2xqQVZvT2ZqbjRTOUhKejMrLXdRKy1KV2xiUmdnWTZN?=
 =?utf-7?B?Vzc5bk1LMUwvWTRCYnAyMFBIMUUyUi9aZ0ZmZystUGtDZzRvRmwvMDVnVnNP?=
 =?utf-7?B?UDFjbFBuSlQ4b2hkWEtEOUVjNk4rLVhRNlZDU3BzVnkyMTNCNktYNWJJbnNM?=
 =?utf-7?B?d1BQKy1RNk90RWRsMHQ1RzFZNEVvclBEc0ZTQVd4Y295L0NVWmpCU2x6UDQy?=
 =?utf-7?B?VXRlUUwyYlJWMlRiMElCUU9hUzBiKy15OEl2dnR3cmVKd0pOcXIrLXRlOElk?=
 =?utf-7?B?WHVtZ2hVVUdUSjkzY2hURXhYblBkTkQyYzFzWks5bHRhT0dwcXRQaW5aT1dm?=
 =?utf-7?B?aVIzOCstd1dNMkVuaEVRUWRXd1FPMmpGMjYzZVI3ZU9xKy1kdVpCZHdYRnA4?=
 =?utf-7?B?YVpPKy1lQ1ZMZ3cwT0E3WnJ5WUFxeDI0c3l3c0d2MFN6UlBpSHliOFhX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?a0k4TGhjeEkzWi92ZWRZcndsLystOFlOankySEowZ2J0NUhWdWN1OWhsRm03?=
 =?utf-7?B?S0JpVWdBeUhjc1hRN3U0UHJSaHRRRlZwdSstKy1xNHFaUGJQWHIxWmQ0dFZH?=
 =?utf-7?B?dmg3N0JPZUtYd3Rhek5GUVc3eTNrNXdkSG10TlExcWtRQ050Y0JIVG13amVl?=
 =?utf-7?B?YmFkc094eklVTjJrdEZNZHFBdVZqSU1CaGdXZnJmSFBhQ0VYcmlqSzJENmdi?=
 =?utf-7?B?SnRRSEVVbWF3MVpXcjlKS3ViSFNRZ0VnUDdvRk5JbUVEZDFxaERsenMyRnpQ?=
 =?utf-7?B?dTRsdmVIdEd5T0lqNzNLZjdYZzFmd3haTUJIVHFqbCsteFRJMHdPWlM0L2Zv?=
 =?utf-7?B?eFE4VWIrLUJ3Z0RHV3E3aFgrLUFaUzk2NUZHUnZVZmxqemwwM3A2SjZZQ21C?=
 =?utf-7?B?WGhFcFJkWDN0VGNsYUUyOE14YzR3ZnYwOTlzTTFXTU50Z2FzOFlRS3Z2bFJr?=
 =?utf-7?B?aXJ5d2M5S04xL2tRWVJSeW5NNHVnN1ZMTmExR0ZrOFNFY29ES3lpODFUaU5p?=
 =?utf-7?B?US9uc2s3L0xRRGNRV1J2cmdBMEJoUFQ2SWxZTWRlaFQwTUQ3S0d6YXROUE00?=
 =?utf-7?B?ODE4TDl1REMxSzVJZkpMKy16ZTgyTEx4SElmYXVNRTJRRHlPTjlLYzJIeWM=?=
 =?utf-7?B?Ky1LeGtjNVN1U3BJWWlSNHRJTzFMc2t6cmxFTktyKy01dWZFaktnT0VtdWJl?=
 =?utf-7?B?bzdXQTZvZldXN3NYc1hJemh2MURJaGo1TDNUdlhmSWFlRElidnJYN05qR2hh?=
 =?utf-7?B?VHFEMndYUGZlaExYWUJTaXhJTmJVNDMrLTRrWHZXSWNkTmwzZHlKYlJIMEZo?=
 =?utf-7?B?Sm9vMXBWOGRZbHJSU0pNTEpJSkRFZ3k5ZUZtaFFpVlZSV29FWU1kSTRrT3Bh?=
 =?utf-7?B?YWNzQnlTNFBaNUVEcWV1c3FnTVU1STZMZ3dyb0tQY1pkWVBlbGpUN3g5UFZK?=
 =?utf-7?B?NnlUZlcrLXBma2UxZG5DRDhTSnBQSGFiN3FKbll0eTdQNjd4RUwvYVp5WnlF?=
 =?utf-7?B?QWJFMXBuOEFLckhtM0M0UWFCa2hYL1FrZ2ZzWDlNazhYeUpQNzZ6TGE2WUJs?=
 =?utf-7?B?RXRTLzY4ZjVZcExneGhPZmJrT3dlU2JNL1dZbS9IN05BR0N5Y2NySG04RzI5?=
 =?utf-7?B?M1ZUMzlXN0djSk0rLUp5S0UvZW9id2dOTmhFUUFheVFjeGtVTjAxMzB5N3pF?=
 =?utf-7?B?bmR4VHhxWkNhMzR4RVRDT2tFWklUczZUeXpHYmQ5b25UUE5CQlMzRHJ0R2Rl?=
 =?utf-7?B?RUR2bmRrNk5HQmRleURrVU1UUXZoazJDejNCRldXaU55RzZXRzdNbEdxeHZh?=
 =?utf-7?B?MmhEZFFGbkx5OEtFZG0vT2FMZlRDNzJVSldOeGJlVEVYRFZWOUtTMWw0NTYw?=
 =?utf-7?B?U1dhaWsrLTJ0VGczMVFwZG1EOGdEcG1rR3p5SEx4QSstTkxNSFJacUVZWG5X?=
 =?utf-7?B?cjF2ajRLemY4NXRZZXBubTZHTnhYTFBpU2EzbFN1U0ZqeUhlWk96VFQ5VFVv?=
 =?utf-7?B?WGk5R0l1SWl3ZjQxWUpmbUF4bFlZbVhJam5ETG1ubXI2ZzdTUUJlOThRcTJn?=
 =?utf-7?B?TTl2TzdKa3ZiVzV2YnRRRFBCU0hYKy1qNGE0T09sZ1NDenVTZHpFL01FNWk1?=
 =?utf-7?B?Z0F2ZDBtOGl1alptL0xzN1J4b3NadXJidnRhSkZqVkJsRUNpcEVYYlNjcWI=?=
 =?utf-7?B?Ky1ydjRCUGFBbHVYY0RtV2MrLXZpM2FkVnJlNlorLTFobWI3Ky1xMmh4UlFm?=
 =?utf-7?B?VGdGNlJJeDc5Ry8xa0ZGbHBpczU4UEhPUnZZRWphNjFGL1FUT0JQTmY1RDdw?=
 =?utf-7?B?NWdhZWEzZk5QbE1wSmp4S1U3THp1Wm9IMTZLOUF6M1VtbVhkN0NDM3J3SFhj?=
 =?utf-7?B?Mm1oL3ZoZ2NMTHJtODk0a3BFS0p1cFFaeExUSExpT2psVzZrN0s3YWg0Qmhj?=
 =?utf-7?B?NGdjYkZHWExFcE1uaVdDYnFOUjVRbmVTSldOV3Mzb1BxZ3Boc094Uk01LzhK?=
 =?utf-7?B?NmVsUXBoZEtORTRyQTViUmJ1d2RGNXAvM3NneHlqMjlIVCstbVBpazVrMk91?=
 =?utf-7?B?UGVuOWViYW8yamhnOVM0WjVXVm43bVNVeFFhSjBGbzBJdUdueEwvcXFTTGcz?=
 =?utf-7?B?QVVJNDhMSWxhQTNvcW85THFwR0xJcXErLSstOWhsQWt4L2RFaENZb3pEaVNI?=
 =?utf-7?B?OTNPTjdZY2ZDRUxPeW8xWCstV3N1azlwbDBTSk43dmljUWxvUTVZU3NTQUYz?=
 =?utf-7?B?NVNQaDIyd1dxZElMOU9jdlBMa0QrLXNueg==?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7162ec35-0c11-4f6d-94d9-08de1bf85784
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 23:17:36.6877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U5+6TFauwm/A9Q2TI0JTaUm3VD002cQG8GcqUzar2gfwxZC8/maXkJpmnToQwbD6vUrHx69+8ZJbY1RmKGizYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6351
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-12.cisco.com


Cisco Confidential
On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke +ADw-hare+AEA-kernel.=
org+AD4- wrote:
+AD4-
+AD4- The configured interrupt mode might be different than the resulting
+AD4- interrupts mode after all configuration limitations have been applied=
.
+AD4-
+AD4- Signed-off-by: Hannes Reinecke +ADw-hare+AEA-kernel.org+AD4-
+AD4- ---
+AD4- drivers/scsi/fnic/fnic+AF8-main.c +AHw- 2 +--
+AD4- 1 file changed, 1 insertion(+-), 1 deletion(-)
+AD4-
+AD4- diff --git a/drivers/scsi/fnic/fnic+AF8-main.c b/drivers/scsi/fnic/fn=
ic+AF8-main.c
+AD4- index 4cc4077ea53c..7075a23d9229 100644
+AD4- --- a/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +-+-+- b/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +AEAAQA- -678,7 +-678,7 +AEAAQA- void fnic+AF8-mq+AF8-map+AF8-queues+=
AF8-cpus(struct Scsi+AF8-Host +ACo-host)
+AD4- +AHs-
+AD4- struct fnic +ACo-fnic +AD0- +ACo-((struct fnic +ACoAKg-) shost+AF8-pr=
iv(host))+ADs-
+AD4- struct pci+AF8-dev +ACo-l+AF8-pdev +AD0- fnic-+AD4-pdev+ADs-
+AD4- -     int intr+AF8-mode +AD0- fnic-+AD4-config.intr+AF8-mode+ADs-
+AD4- +-     int intr+AF8-mode +AD0- vnic+AF8-dev+AF8-get+AF8-intr+AF8-mode=
(fnic-+AD4-vdev)+ADs-
+AD4- struct blk+AF8-mq+AF8-queue+AF8-map +ACo-qmap +AD0- +ACY-host-+AD4-ta=
g+AF8-set.map+AFs-HCTX+AF8-TYPE+AF8-DEFAULT+AF0AOw-
+AD4-
+AD4- if (intr+AF8-mode +AD0APQ- VNIC+AF8-DEV+AF8-INTR+AF8-MODE+AF8-MSI +AH=
wAfA- intr+AF8-mode +AD0APQ- VNIC+AF8-DEV+AF8-INTR+AF8-MODE+AF8-INTX) +AHs-
+AD4- --
+AD4- 2.43.0
+AD4-
+AD4-

Thanks for this change, Hannes.
The fnic team will review this and get back to you.

Regards,
Karan
