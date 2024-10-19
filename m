Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998C61CC8B0
	for <linux-scsi@vger.kernel.org>; Sat, 19 Oct 2024 06:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729319069; cv=fail; b=stXbGhd/CnrvXdYUL1LybGYDNx8ZikMWK6FCLul6kOKQQg3yRVb/fmOs+BYyD6FDZx4UNrVIEcu0UkSPh97oxQ2ENL7N3Rkxd5HWqkbxoy4/8EZ5+jxYRrY7dfklPypHZ0LAg61MYNDrk5YkyqpSU070wGIFU6TYSic4aQKPb1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729319069; c=relaxed/simple;
	bh=pMlraYedaT8LS1RTJnYrBtEZLdWV2hPdbz2DbkQLXv0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k/mSNvJLbA5OXgcSLF/Cfh3PHvxhYkFHyPdc5ty3GZfi8JAEaggijVxCqUGYHORpsk5cFWF2E/uYsl1mbMWM2DvaYCgzpQXstuWV0qNj5C3YsChMgnORBMNk85qnMDwEuPPv3Dr5vAOiHmqBJ1/cm87bL+KaUnD0LjxIX9+FnY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Id32hw5t; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FCEqqd2R; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Id32hw5t";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FCEqqd2R"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729319067; x=1760855067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pMlraYedaT8LS1RTJnYrBtEZLdWV2hPdbz2DbkQLXv0=;
  b=Id32hw5tpqyLKUUbxqaHZhWiev/0lVfXJPhXYVi8eYuTJoG+HwX5lWvR
   iwTTDPyLqmSWQA28uAI81WLTPTFc5Y/+4qLgzmnxNs6pBNHwV+kogewkc
   BjyoiTGGFXEpT12JoS4odvajV5d2j39uaNHYNhuHevadTvK53tVimbLlb
   QNObMdt/kE6cuymvNGylxmgDcer3rd2dQ5kE1W7fo12F0nUXLSwcKyHwU
   3bM5QT2F1OaCLYQEHdWKw6+3VXQ1RZtmU2ML+M9XzRHHk9fVDOByFO2Ic
   9BFgtP0rpCoS8i/2tgu31aCPtjsTcTPh+D+mz+REpRxbRjIXhJB7EHW9E
   A==;
X-CSE-ConnectionGUID: JSbi7FaQTmeq3ltMijdHag==
X-CSE-MsgGUID: t0CRztCsSZel9TzwfG8CXw==
X-IronPort-AV: E=Sophos;i="6.11,215,1725292800"; 
   d="scan'208";a="30288955"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2024 14:24:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nKs6vVw2VFWP63p/Q8ARX8Zuj2T4AtwuhM5QNBVwk8KQgCyQLyQUNdUJtX1ggvNIbdyHEkUv/v1CNBmfXSuhudL0mwBRNcM2LXDxwq0OvPrDjrozhUt3O1GwqgMsTES+jcfvi9K6gXUQbqbirpg39+tY21l2xsK7IZ40mewrtwEKb9DA3N/qeD5Sx7n/QVDDCB6jYMUyxElKua0n25/gY978oyUaXuiLRHlEF1kDB8lYtM1mms7oOh+wDk91SQB2IGwATEPwebx/RN2ngsPEMKYEsuhmNPMIZINK7mriFTmrWU3f7KAENHu6HMe+SdWkqFKj+DwzXlGOzZwZuRApGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OveduKkLZ5eJpiJrBotnGZ6CMG5vy2mouJUbXmrqHlQ=;
 b=KY7Pxzb3EolFlJpNrmrLVV/7HKjFSxQdrrouZynsG+XTVDDyTzPjrAYRirVo3JVn9BJlpAOdI19OR+gDVimilZPgspMbfyULC8vSNLZGTQmYuP+yECGdst4YXuAVRZQEZg3imjYGcfaxPh0Y3Wx2A4cj85cTpP5XP+/FNrtkn6g/xyXEnTaVVt1LTAzyflGM5OH0XJUxN6C2wCGFex0Ebyai1YKGMwxMx3gAtPNUBxEdzv1zfFqx5WJoEoCfi6+Vhhs+gnZ34Whs/UgprEIh4Cl760BMTXHlpKDxXVzBy28OuVwXoXgbMxMShtihSp3wd5DrQ6BVPGfZseNb0C5CcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OveduKkLZ5eJpiJrBotnGZ6CMG5vy2mouJUbXmrqHlQ=;
 b=FCEqqd2RC+ngdEd2fui92GsAlt4I6/wxdc61sHhzhCH/7THSr0DgkgUDkdgywxb+NkYFNJfFeYskINZiNqoJeZXcUxewhHCBBAReRVKGBQuwHeXI+uT7d1RhpcRso6/MYkn6dW7WcirmFvIkUrra1z4YgY0e6fmDAI8yqc3mGHQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SN4PR04MB8384.namprd04.prod.outlook.com (2603:10b6:806:203::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Sat, 19 Oct
 2024 06:24:17 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.020; Sat, 19 Oct 2024
 06:24:11 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Yoshihiro Shimoda
	<yoshihiro.shimoda.uh@renesas.com>, Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Andrew Halaney
	<ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>, Maramaina Naresh
	<quic_mnaresh@quicinc.com>, Eric Biggers <ebiggers@google.com>, Minwoo Im
	<minwoo.im@samsung.com>
Subject: RE: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
Thread-Topic: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
Thread-Index: AQHbIZato9yZE/MjkUeGYMJmS6EW7bKNlnnQ
Date: Sat, 19 Oct 2024 06:24:11 +0000
Message-ID:
 <DM6PR04MB657551A72CB90ADDEFC49F48FC412@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241018194753.775074-1-bvanassche@acm.org>
In-Reply-To: <20241018194753.775074-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SN4PR04MB8384:EE_
x-ms-office365-filtering-correlation-id: 883fe38d-1e97-4aa9-c7f2-08dcf006a575
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?bnvblTe0ba7/WymEkezmxN/ZS0XHC8TGTnq1648o5cxsKkq4MqIRimFLNXHv?=
 =?us-ascii?Q?wT3BT6rIzYzmST8b4rNwNrhtLEqLtRnD5TUHnGHKfJQJIFEU268X7xxe7fyG?=
 =?us-ascii?Q?F43CVBNlmuN1Z/Ldl5BmpTscPdeNDOfCCfb+YTZOggj+vCxroXYJ/JZnallg?=
 =?us-ascii?Q?pYGLkIl9tq2Rc523LHpvU/pfoXJElg8JuBLJfkEfm+noRy7DhDHw0nSQt6jT?=
 =?us-ascii?Q?o7SqALe+8ZoaSN8vKwxDPlKD1F3raAzdockLSPO4yYS+4Xf+BeWHmf0yNA+r?=
 =?us-ascii?Q?7BlbRvwW0gDR1wdoHvtH61/8I0rRZDBXgVmvuUWGTlJFz006LatOPANlbyrg?=
 =?us-ascii?Q?ZVSFjCY7tyznL1haNhKqURHRUqmjG81Y+AkWakFMz5UeoJHsUrxbEtdLRSO2?=
 =?us-ascii?Q?FGD5JmpgMb/9ypkgn2sGNvDpSpeUh6RkQaJulvujcQKD69jZmk75MInIeVs8?=
 =?us-ascii?Q?jIFiUpCgC71nZ03oLVu4ldzlN4juWNpVfcJ5kQdsa87dAE3Bpk7Ua9W1Q30U?=
 =?us-ascii?Q?WyPyEMmrQig0zdS5lCeKkvdIx7dNUf83xWqYHYVRdPGUT1uD8SwGcMFVKfFr?=
 =?us-ascii?Q?3lMthSlDpWTvpfynwL3Jp6n+zy9yMegLa0zbpu9EFVBTZrV+6JM017X83l9c?=
 =?us-ascii?Q?MxNcsVZrvb2mOtJGS8S/FyWRtv2RP4qTIXywtKxK9wyX/2S4+pNRi/A6roPW?=
 =?us-ascii?Q?V2ITKdWBzRGf7lu8FdHae31KixJcO4wWEel0QbEcFuuZF2k2K49sXa/S1Vey?=
 =?us-ascii?Q?6LNEdfhYEmchYQ6oADbQauQM28i91sX+QjnqEsIeObt3LzzZkrJOruNSBCgM?=
 =?us-ascii?Q?Te26JmImGKy0yc4C7Tyig7up0RHfx2G1ag2UWWI3xu7xfWIRaARZGdMT2sFL?=
 =?us-ascii?Q?SH6OriccQycDi0RliVm9XRrQ+BAwkr/ll89NAEqFG8lTls03CpZnX214FmQ+?=
 =?us-ascii?Q?znVbXEyRJt/VYoGJmDtmkwFjwrtSsII4/o1h8qPqqNZ3Nh1D7PmMRJzbZ09N?=
 =?us-ascii?Q?8uvAkb8HZUDeJkJNg/eXiEPG+RT8eLsaT9OhhQPA2LyA5rm9vZCWYrX/IJxV?=
 =?us-ascii?Q?Z/wTsnhREr4eFnw6noKBZq3qUhsXIH//DJ/xaVf++/AKWqBLfeZ/whHEugG6?=
 =?us-ascii?Q?vqPNhDFhms21smYnECQR8xL2H8klST7IwRz5NcYCVF1dWiYQJ5vBJzARFahw?=
 =?us-ascii?Q?wIht70f+zGIS/SZ48eyXv0bHwPlMelWwq4YHK+OqvPwHK9R9lsb9dnD+fuy8?=
 =?us-ascii?Q?mucwtFKHQKHS1YhhCwvuF2wq2zBJr4/9LJVmpnTD1nSLvXJSgLFwhUF8E9ei?=
 =?us-ascii?Q?HsNMGG9+X7rMSO8zWkhy/LLIC8ksO7ZCy3unW03G1kHPm8mWKYHy3r16N+Rj?=
 =?us-ascii?Q?zl7P5oY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Ef/PnW/YVFxXx4bd03M3bFLRfcOu+UCL5M5i36axsQuOn1FLIj7D/svViRJA?=
 =?us-ascii?Q?9VLw+Dw85cLXNYdub+/aTZeF1QcqfoWtvbsI5iSRwe6igsC0o8q8gbrms56A?=
 =?us-ascii?Q?odmVPJ4zBHifstzyBWoP4Z3sVWi5IWBpqPpZiXLO9YgmY+1Cfhn8sDL59SrA?=
 =?us-ascii?Q?ZqzYDAjCGfn5uFpnZ/f190jBymv3zIs8/3SDOhxIbtUBfbnHIeML6yYVGJhW?=
 =?us-ascii?Q?D5BVTLWfxszQTQ8eIdy8GtRsWL4M6d726a0lhBqDlOPKQSc+m9os/Dz55ZQ/?=
 =?us-ascii?Q?aM5Hp40pSI/uTa7OTaiW0lOfx7uli85Cnwt7asMwnBfubi7gXgHYdPGXjung?=
 =?us-ascii?Q?k+D5u4LigkjCJyq5+2PmbEuB0XucZzoSnB2fhVbFbjfgS43Ko+NgDZ80ZK0f?=
 =?us-ascii?Q?CmOLJ+QmXssZdlOGsPqk7YDZcNrmtHHxEqxIdCjGeTJE4b0dJHjAjrZ977HF?=
 =?us-ascii?Q?67v9XcLVSnm4TdXTDnMgvlENG3AEUjh1YXz6E4HtAvbSMRRC8zdguEm/Jcth?=
 =?us-ascii?Q?pax0yXzShiolZSKUfMKclGKO7F6vSXl9JNQu/FTGTlbJnAjvzfpNT+yi2PC0?=
 =?us-ascii?Q?E0lqPFsE+s7m36Khn+U8tgnX/XHVbxVqdCVrPCtAqsWZL2qjDXilcmDKRpQl?=
 =?us-ascii?Q?5KBYhmLj88eQAljjXcMX8Clf6cDGoSOk9gu5i/fOMX+h+Bkq1sf3Ir3WwnH1?=
 =?us-ascii?Q?L2HQj73M9Z91bHkL++00JFTkCGRNlzcd012H1c/85/rLfdhpfWMkQIKvDlkG?=
 =?us-ascii?Q?27eBmGoy1OXm9KJy6BWHMrh1YTu4oYvcURhD4++FEX3Hg58MOuK2/a/CirUd?=
 =?us-ascii?Q?3V8QMvj1cmmo/nEb1RVOU3QuV5bgT4xZWva8jK9lVqT6yJnzGBafJonaHIjH?=
 =?us-ascii?Q?SZrOqsN6L7mWiYolBkgS7gfimmI/Ab8CGIpMvpecGWO5Q4+EBHW1qsIqQnjb?=
 =?us-ascii?Q?/HWy1CA4mBf38sOwCfaMov5mfGd2Xw2c2OlZNyaAbkKJd0zeQ1BMqGlJglld?=
 =?us-ascii?Q?um18sR769cwaXsQ1+HYnofrRwT9VvCLzCMTCXHDieGmjZEvoF4WXiLM8+aYY?=
 =?us-ascii?Q?5oVMxy0h7EuH+6lZXltf4p8Py0+eEULaeZ2KTsYWsg66HW4/x0b0N5wBVX47?=
 =?us-ascii?Q?RkGd09YUShvwyoSQrBCFrwz9iFUd5hkxyy02OWpoeTxJ5ObspNeahY2tFeJV?=
 =?us-ascii?Q?kUNyZHL1jys5+ZzfHH8lEWGFQKNrxMv/5p40nFk+eUYLnuN8CbgiQWRy1ETq?=
 =?us-ascii?Q?HWjJW2p1U2GJBBW45GZhOLLqpaTW0JKt+lpHZjjbB0ZKUBnpNCoYeGX/1fcH?=
 =?us-ascii?Q?DjoNC68ZBaUrlxGafg87Wwf1ZF6nLlRo26p4qu6sVgxs7mBlqMbMaeC/82zh?=
 =?us-ascii?Q?/FE+ziEYN6MVxUbzUpUQH+Dp79htrcJ5b0XFJwIeF/0y2NLHQCsxe5C2hvmt?=
 =?us-ascii?Q?1NhFX9mtSPjxdw4iiM+m0PfxmBW+brFMuvShF0bKKnZ7XN1PSEYVf2oFsA0n?=
 =?us-ascii?Q?wqA+9zXxIL4YB8IXBQaoz/amgTRvAb9yz8+tNLjk0SH9L+LGApMjmzLCXMbv?=
 =?us-ascii?Q?WISoieuHXF9LfcWXCnyb69xOyIQyAHuacaPw75HFysNZQjcZZt4Xoc3g6sKf?=
 =?us-ascii?Q?5Fp1/SRlQFa5coOPVM215XgPjtRrWK5IM5vUmWnYTHrV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HHjrRwFTIXGOeGxEaeoX+dvBrhuAYRFAyxSexC5bgVwZtCeABEvgA8nsiI6DBQO6fR8XPWWVwu6f1LJkfLTmjSFxEOc0/kOwFnovI8qo+jg+jIH1uyc9Jb3GNPHDpLjZHUyO3wrv43r5X9zW5MpYaX4Foh2wPcfq55w5q5SflRSCcM8MjfORk2uwL6xZnaD8SCb/x82jcv6h8+cFk/w3b9Tb+FkKnw6+PnjSEvmPL0/1c1Xlfz3lxI0qO7HJRC6B8MzG1mIJVYa/FMoDEZhsGtt6RSQWVlu2zjy+apQVCI7rqt5n2d1EgPEKMm5f9RZ9+hLnYNWoBEZvrgHuyASrznCaxN59efWpmSGqQPEwI69DenetaZaoIfL61S44t67L7a/cjNsLj0kKcHCi5ksCVTeYE1cz/gCHHCXY+5nZNQuMinceowteY7/3TISfs0PUoU99s/UL4/9b2SX4IG0hfDpXwizxjutyZ6F2IpWrZhqu52mV4tDbdSemxNI08Wkbkt82Gsv7tYVcjNg1XjfyvTdyhs+x9B4+hsvdwPp9EmZvm6CPZjoMrWhqqVXSzNB8MCeKa7dUv5EZTb9eSXRDYCSNRmwqEonHcLdMHo4+RGcE4B3O7F8rlKTCrx1l6Qqe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883fe38d-1e97-4aa9-c7f2-08dcf006a575
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2024 06:24:11.5807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImU15wPcEBTW6yjgFJi0q4MY4R3EafMhLHTDiUk9c2g3XSjuO2dzGl57TwXbsUikAWU/EEr0qG0j/VcLRMJE4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB8384

> Replace UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS with
> ufs_hba_variant_ops::set_dma_mask. Update the Renesas driver accordingly.
> This patch enables supporting other configurations than 32-bit or 64-bit =
DMA
> addresses, e.g. 36-bit DMA addresses.
This patch allows to ignore bit 24 (64AS) in the host controller capabiliti=
es register.
Personally, I am not religious about quirks, not sure however that this is =
what vop is made for. =20
Also, there is another host-specific option, e.g. the opts member of struct=
 exynos_ufs.

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Looks good to me.

Thanks,
Avri

> ---
>  drivers/ufs/core/ufshcd.c      | 4 ++--
>  drivers/ufs/host/ufs-renesas.c | 9 ++++++++-
>  include/ufs/ufshcd.h           | 9 +++------
>  3 files changed, 13 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> e0dba0e3d5b5..a1eb32d301ae 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2389,8 +2389,6 @@ static inline int ufshcd_hba_capabilities(struct
> ufs_hba *hba)
>         int err;
>=20
>         hba->capabilities =3D ufshcd_readl(hba, REG_CONTROLLER_CAPABILITI=
ES);
> -       if (hba->quirks & UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS)
> -               hba->capabilities &=3D ~MASK_64_ADDRESSING_SUPPORT;
>=20
>         /* nutrs and nutmrs are 0 based values */
>         hba->nutrs =3D (hba->capabilities &
> MASK_TRANSFER_REQUESTS_SLOTS_SDB) + 1; @@ -10277,6 +10275,8 @@
> EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
>   */
>  static int ufshcd_set_dma_mask(struct ufs_hba *hba)  {
> +       if (hba->vops && hba->vops->set_dma_mask)
> +               return hba->vops->set_dma_mask(hba);
>         if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
>                 if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)=
))
>                         return 0;
> diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesa=
s.c
> index 8711e5cbc968..3ff97112e1f6 100644
> --- a/drivers/ufs/host/ufs-renesas.c
> +++ b/drivers/ufs/host/ufs-renesas.c
> @@ -7,6 +7,7 @@
>=20
>  #include <linux/clk.h>
>  #include <linux/delay.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/err.h>
>  #include <linux/iopoll.h>
>  #include <linux/kernel.h>
> @@ -364,14 +365,20 @@ static int ufs_renesas_init(struct ufs_hba *hba)
>                 return -ENOMEM;
>         ufshcd_set_variant(hba, priv);
>=20
> -       hba->quirks |=3D UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS |
> UFSHCD_QUIRK_HIBERN_FASTAUTO;
> +       hba->quirks |=3D UFSHCD_QUIRK_HIBERN_FASTAUTO;
>=20
>         return 0;
>  }
>=20
> +static int ufs_renesas_set_dma_mask(struct ufs_hba *hba) {
> +       return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32)); }
> +
>  static const struct ufs_hba_variant_ops ufs_renesas_vops =3D {
>         .name           =3D "renesas",
>         .init           =3D ufs_renesas_init,
> +       .set_dma_mask   =3D ufs_renesas_set_dma_mask,
>         .setup_clocks   =3D ufs_renesas_setup_clocks,
>         .hce_enable_notify =3D ufs_renesas_hce_enable_notify,
>         .dbg_register_dump =3D ufs_renesas_dbg_register_dump, diff --git
> a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> 36bd91ff3593..9ea2a7411bb5 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -299,6 +299,8 @@ struct ufs_pwr_mode_info {
>   * @max_num_rtt: maximum RTT supported by the host
>   * @init: called when the driver is initialized
>   * @exit: called to cleanup everything done in init
> + * @set_dma_mask: For setting another DMA mask than indicated by the
> 64AS
> + *     capability bit.
>   * @get_ufs_hci_version: called to get UFS HCI version
>   * @clk_scale_notify: notifies that clks are scaled up/down
>   * @setup_clocks: called before touching any of the controller registers=
 @@
> -341,6 +343,7 @@ struct ufs_hba_variant_ops {
>         int     (*init)(struct ufs_hba *);
>         void    (*exit)(struct ufs_hba *);
>         u32     (*get_ufs_hci_version)(struct ufs_hba *);
> +       int     (*set_dma_mask)(struct ufs_hba *);
>         int     (*clk_scale_notify)(struct ufs_hba *, bool,
>                                     enum ufs_notify_change_status);
>         int     (*setup_clocks)(struct ufs_hba *, bool,
> @@ -623,12 +626,6 @@ enum ufshcd_quirks {
>          */
>         UFSHCD_QUIRK_SKIP_PH_CONFIGURATION              =3D 1 << 16,
>=20
> -       /*
> -        * This quirk needs to be enabled if the host controller has
> -        * 64-bit addressing supported capability but it doesn't work.
> -        */
> -       UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS               =3D 1 << 17,
> -
>         /*
>          * This quirk needs to be enabled if the host controller has
>          * auto-hibernate capability but it's FASTAUTO only.
