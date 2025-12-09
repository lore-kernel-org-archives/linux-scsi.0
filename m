Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489CC19005E;
	Tue,  9 Dec 2025 03:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250482; cv=none; b=ABTPFVD19j2bgiDYFDkhFh79UFs/zI7ilbzb3FZTq3tr0yaxT8z7ssURYvUqqfotkvgE0urtzAqqqacfA/2M4qBSmPgrsoyj7EL0InlNwG+IVtLzenFyJLYbdTLPcMu+iiOBsa53ZxbCA+M9YyfzuIOYWc2SIWy6udX3Hs7kRXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250482; c=relaxed/simple;
	bh=1D9qaaNm9ZeVgekeiBfYyTYwWUys3RJUvPZ8lCVs+pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k9O2hGsTWswQmmbUZSz0wjAJMmqvPHtX0Og/7K4/H0ezCft1U8xYEmStW3NIhxAlagp8xOXwcBjNTOv4a3pFSlGa59u+1XZY8mOAkNGEtvbuPROsbxWVavqk8KH2nOujzS2XMy7EHIfXXR2JtfDTGk88m5u2kdPEEMj7xh+7wIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cZzOStrW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cZzOStrW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B91gJQ43845566;
	Tue, 9 Dec 2025 03:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZjfTuaNB/XY8mIjqNihzx0WcIDc35PfzXllb9c/tYtM=; b=
	cZzOStrW6LcJC6Bk8PDl9SouzUFJcMZDrQbaeXGeArwKIJiJI90lyRPcCX19lYmr
	XPW2MwIwjfJNeBR4iJfSsJi69OXNMpyX0a7gySPKqXUmtDMigUaj7yBRyzj9kTqR
	NO7Wi5lCirAo1CSd+KidAUib30porrTan3krUG8hxiay+kjfeOjiQtU+iKKLNORg
	sQ+MUqLPqHW5ts80LkJIL0W5UzsAg0t0XQ5NZXbCGDnOkYg2so0iIcAS7GbCY0RQ
	/3+cJsdkanoel0i637WzGYH+c9AU+6cSlESHHQX+/zmbzWXlhMkasHVgHkyVvGlp
	nKqW10H4D002r2Ym85QQ4w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ax9c684mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91FZbN038209;
	Tue, 9 Dec 2025 03:21:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j00t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:17 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4FS022652;
	Tue, 9 Dec 2025 03:21:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-3;
	Tue, 09 Dec 2025 03:21:17 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] scsi: imm: fix use-after-free bugs caused by unfinished delayed work
Date: Mon,  8 Dec 2025 22:21:02 -0500
Message-ID: <176524933130.418581.8604572296942599990.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251028100149.40721-1-duoming@zju.edu.cn>
References: <20251028100149.40721-1-duoming@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Authority-Analysis: v=2.4 cv=aKD9aL9m c=1 sm=1 tr=0 ts=693795ae b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=cBp7PEOAEHQrr6jRSKsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: lW9KrC91eA9WrWTCraNo-YZe3A0VWDln
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX+u3QSDkOML/g
 qmkLFdD2IAZNVqdPQ4e4poZN82c+GxUm8j/m7x3VHr/A/0w6LKJ89ksM7zCJPdd78li6hdnhuUg
 QkFc3/QwKGBQYdIh7XGK7Lv81wkbmr5yuM2hJvb+RuWxsYS2xhpZrUJ0rTgtViG9A4Cb7rTuk1o
 3TDgF+lav6NOcPWOUs9aQ+5v2ovz0Ly/rlAl+pe4tibMjXX5B+Vt3k2EQFJdPB1xt1Mv2Fw9bwY
 IE0ilwrNk/qIUTtzB3dE3PFdYemZtfXoppUpg+Mg778/mIJ2X+zaAX+Y4i98aXfLsJP8a+4PoOm
 9MFebn3bycHbf6j3Cosb/6Lbqg3hH1XNauL/Y47rA1xChZMMrKp6tdaHrbevzlR3wIwgT9WpNBv
 CTYop1ckscpr/bcPX+0pVw8Vv5dLFQ==
X-Proofpoint-GUID: lW9KrC91eA9WrWTCraNo-YZe3A0VWDln

On Tue, 28 Oct 2025 18:01:49 +0800, Duoming Zhou wrote:

> The delayed work item imm_tq is initialized in imm_attach() and
> scheduled via imm_queuecommand() for processing SCSI commands.
> When the IMM parallel port SCSI host adapter is detached through
> imm_detach(), the imm_struct device instance is deallocated.
> 
> However, the delayed work might still be pending or executing
> when imm_detach() is called, leading to use-after-free bugs
> when the work function imm_interrupt() accesses the already
> freed imm_struct memory.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: imm: fix use-after-free bugs caused by unfinished delayed work
      https://git.kernel.org/mkp/scsi/c/ab58153ec64f

-- 
Martin K. Petersen
