Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DAF3242BD;
	Mon, 13 Jul 2026 02:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910042; cv=none; b=izW7aj4JZcOl86n5lea+iZxpBUzgocJEIrOa2T47ryJhA+tFD3SAJaTz9sf3cUm148aOC7UWbGhhjbKM6IUVRQUCAGmYyQohWjidQnxqDDr7b8vu+HUQEdQG067J6ubvSDWOxkA0DGzYtRS0C5Yv8egxrYRd5s/cX27+NK0dfrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910042; c=relaxed/simple;
	bh=oSLzEXXJYuQSfapPi1oGwtRb7i/oVqLac2+KXIUxvjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlYBgAuKD9q1FqvzPxXMauCj/pr0UvC3kfWSGEmQb1bbnCovrceQBtbnyqxnHNjsXiAKxAZgnJj3P8ircR6AyYHXxGJdEIQulBHm4UIZrCJomihVzVMJ5fZbo6eurZAXTEsC4YT/HflPD363Po5i6CYjxrymtKo+c3DMRWGffYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EoaCxD3/; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EoaCxD3/"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D0Q38E180572;
	Mon, 13 Jul 2026 02:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LKIzrYZnAO25BPi7hCa7lAndiDK+9kkZWsaqBGlKrZI=; b=
	EoaCxD3/qk7aX6fCv4ZQKfyxejWOQycjTgdsw2qNac5HF/8F0/0Ce/Z01jOOg6LY
	I7u+oJqFquBQOm3cylaTvDh2/YWSoNOD1Afd1USuz+5BOsoQotXhV6M3ISdXv/Ku
	rxb0sYNYFtIOaDW1HdPW1OlhQ1Lm5FPPy9DnU76cx5fNm4wS1qQfbXaYsb+qDpcT
	K0tgn2wdN1CaO7rj5awHtckExc2IfH//dClyC/wT0OHqZec6yrfMR4iZkE6AE7Xn
	79SUQvi+khuXw3FOYYnvphRqs1eyyanbsCnWPnRmuRGkV42v6jYFDfHpu5atWwmu
	kTueEAaXPHfwhYM7RVC0ig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedhckg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66D2XVPC029136;
	Mon, 13 Jul 2026 02:33:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fssux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:36 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66D2O0ct010878;
	Mon, 13 Jul 2026 02:33:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fbc9fssh6-6;
	Mon, 13 Jul 2026 02:33:35 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>
Subject: Re: [PATCH] ufs: core: tracing: Do not dereference pointers in TP_printk()
Date: Sun, 12 Jul 2026 22:32:37 -0400
Message-ID: <178390967056.3399387.17096580780727607387.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260630185412.283c26c5@gandalf.local.home>
References: <20260630185412.283c26c5@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_08,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=914 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130023
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a544e81 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=JfRuaTOZcsbe-I550hoA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX7fl7dADpiLoJ
 rfPbsgB3eLqU11+PDYBqFP1uAo164JMyxnl0zLBcxlvMm556YcjPBsQSZN/YyFuBPbeJl3JFxjD
 ITX7UbChcf+55oC75iWfQBjZGcT2BreuQsFP7z94EmhPfoLYBrjwkUpq7vEm8KHiTfSzRpb9PqF
 rYUS0MTrTlm+WkxUDaKI3hC+T+XpRMFdLFP2LXSndTj6s0CCyWErzOQP9cabwFgUsZW8HRpjIya
 ahq2yQcj2fPuAprhbLLON49tpkcgbL+RoxOPQ5uKoiPZMTiUG9ojiZ+Hf6d1tHtwrcVZ+BltD1T
 Qha3QPgGpAOqJMJA03EEBUm9sLumDudp4HEU2PF8sIVh/472exHrgDKAgj938Lzxd2MMifgPAEr
 GVymIlxGag32EGVf/oEaDIwGSBVghIoCaGM6+C1umB3x8jhehClZmeVD5ube0YpF+rJKwrcSWb4
 GiCNGktX4xFV+DATMjrsgXlsCWg7K/eUhbp1XNe4=
X-Proofpoint-GUID: Q4KOtfjP0VOMi89s_p_3beBiOA-pXluI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX8JhmXPCgAZ05
 gJ1h+OSshzeErosjYp8x4e5htRwYBuhsNp34FUlTnNxsGDQJYIR/denY+M5dZRMjS5N+DnnkvEz
 PJknAANJrnHpDkFvBNVEGI/lCqSwgL6EDi8HSUp5hCs8yGEzdztD
X-Proofpoint-ORIG-GUID: Q4KOtfjP0VOMi89s_p_3beBiOA-pXluI

On Tue, 30 Jun 2026 18:54:12 -0400, Steven Rostedt wrote:

> The trace events in drivers/ufs/core/ufs_trace.h were converted to take a
> pointer to the hba structure as an argument for the tracepoint and then in
> TP_printk() the printing of the dev_name from the ring buffer was
> converted to using the dev dereferenced pointer from the hba saved
> pointer.
> 
> This is not allowed as the TP_printk() is executed at the time the trace
> event is read from /sys/kernel/tracing/trace file. That can happen
> literally, seconds, minutes, hours, weeks, days, or even months later!
> There is no guarantee that the hba pointer will still exist by the time it
> is dereferenced when the "trace" file is read.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] ufs: core: tracing: Do not dereference pointers in TP_printk()
      https://git.kernel.org/mkp/scsi/c/46aea2c64e11

-- 
Martin K. Petersen
