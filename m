Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306C5287505;
	Thu, 20 Nov 2025 04:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612206; cv=none; b=ICThW6Ir7a0fRLm+fmhU6CeNGN+cIVJW8sqRWBwVXXieXhjDDfau0ENTB8f1uF/l3IyC4jrLO9RT2dRM07JwLIGTVktJoSVHDNh8UBv1gWqgWbMTk6XMybWOL1E3myvYQN1GKKTZBdixFL+9uWsfddwTBQ8HmPSlNfOIpvNi8U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612206; c=relaxed/simple;
	bh=zsf7KwG4jIHMm27qw+zjABzzE16LX7JTf+TtjUTwbJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uTm42n8MAJg1C5dnZGIicHKZJLN3fPui2fwqzHLKLzJlhd38fVFbVXqV1wZ0InAHu86CMj4oj5oWtymoWBVUSKjJA3xlCK0uoIPetqYSrbt7UtrjtrsGtoYFJtmR9EmYJakvrNPnHgILByRHwvzop9mfP9OWopPMHWy4Qc1aOuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nTh+FIZy; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nTh+FIZy"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NTgp029867;
	Thu, 20 Nov 2025 04:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MrqiUep7G/Gw1HkWFRYl8qPzx2p0kOQFd/e68dNi6cc=; b=
	nTh+FIZy4QhTR/+uwlnIrMoPU6XZLZ8ay85dqsxbcJHTxentCKfFDlZEHvskKgh9
	DnsRsto1hoRb1ZtuqBJh88JAw7uoYZjojdqaD/A8627Fnv260hZ2h3Wf+0bsuvPU
	MDonpdxwWGk2rnJOrEu34kqOfcI71ZpllEHkf1Ql9WGJ2AcnRhdj/L8K3oeoZhsr
	EkzRgfkU8KgCqS+YAN1i8bdrrXYXhuEMfJCptFpdKWA7DQGm3fWQd7HnyuxOuD+S
	JVvou3DbdSjEVgUTKT16V2H7ezp7cJaag+vSFyX8gnIQxlJgo7fxT9oBWsX4Sgzc
	4+HLifmpMwFc8ytshhm/Fg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968bhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK3Wk8W007763;
	Thu, 20 Nov 2025 04:16:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:24 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPZ012546;
	Thu, 20 Nov 2025 04:16:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-5;
	Thu, 20 Nov 2025 04:16:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] replace old wq(s), added WQ_PERCPU to alloc_workqueue
Date: Wed, 19 Nov 2025 23:15:54 -0500
Message-ID: <176357169038.3229299.13478986754359023806.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031095643.74246-1-marco.crivellari@suse.com>
References: <20251031095643.74246-1-marco.crivellari@suse.com>
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
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=791 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e9619 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=brwg_7nr3SuNvWk3Be4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: M8eRETrFTYS-ALNdIPIgi4-Uzrg1YrOk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXw4c0gaPDnzqv
 uMY9OvqI7t0i1ZD4IkfKQqEk/ZSXqsyD//y7SE5vZ8zVws2EoQHvBpXrsh+xmSmPG15y7vZw/88
 n4JnJuomtLYwcuq01s2qCTzrezhbCMlaKgCT3Xfk/cQulvkNH/bxFZ0To+H/V9OW+wwARQ/Iz6x
 p/o2m+SZOFGWOb+A1iaH/iyLKEL2UZsTz3IcUaRLhoTdbXb6f3jbZprexaxd/LT5dMEnit9R/tR
 Tzu4qhPhA0AzMkqINV95H22bx1CqJ4F3/LkTsqwUaBeSVls9ZxlDJ8AtQGLXrCjWG1whdjsdwFL
 dZnnwmSQmMhA5q7EmVgl8oZ6nuQKnMMOxap4xOprlCypyPNWI6VUMZRBjDcXPIldCwBgGp/AwPc
 3s5jrVkavGWf/koFapV/72fyJdPKng==
X-Proofpoint-ORIG-GUID: M8eRETrFTYS-ALNdIPIgi4-Uzrg1YrOk

On Fri, 31 Oct 2025 10:56:39 +0100, Marco Crivellari wrote:

> === Current situation: problems ===
> 
> Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
> set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.
> 
> This leads to different scenarios if a work item is scheduled on an
> isolated CPU where "delay" value is 0 or greater then 0:
>         schedule_delayed_work(, 0);
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/4] scsi: replace use of system_unbound_wq with system_dfl_wq
      https://git.kernel.org/mkp/scsi/c/cd87aa2e507a
[2/4] scsi: qla2xxx: WQ_PERCPU added to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/5ca003bb4381
[3/4] scsi: scsi_dh_alua: WQ_PERCPU added to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/afad6b34defe
[4/4] scsi: scsi_transport_fc: WQ_PERCPU added to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/f76e4e1e836d

-- 
Martin K. Petersen
