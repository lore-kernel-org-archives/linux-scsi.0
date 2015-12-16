From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on ppc64 host
Date: Tue, 15 Dec 2015 20:39:54 -0500
Message-ID: <yq1oadruq6t.fsf@sermon.lab.mkp.net>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20151215112057.GC19209@eguan.usersys.redhat.com>
	<CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
	<20151215130631.GD19209@eguan.usersys.redhat.com>
	<CACVXFVM_bSd=SQeNg8gjaXd1R1oFreV+jnWgEVDoVwozcQ5Nbw@mail.gmail.com>
	<20151215165658.GE19209@eguan.usersys.redhat.com>
	<CACVXFVNJR_uo5GU6+Yx6Qq=hRpS+cDzM=xuwDN1V9OjQCm6aCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38673 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914AbbLPBj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 20:39:58 -0500
In-Reply-To: <CACVXFVNJR_uo5GU6+Yx6Qq=hRpS+cDzM=xuwDN1V9OjQCm6aCw@mail.gmail.com>
	(Ming Lei's message of "Wed, 16 Dec 2015 09:15:05 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Ming" == Ming Lei <tom.leiming@gmail.com> writes:

Ming> I think it is wrong to set max sectors from OPTIMAL TRANSFER
Ming> LENGTH.

OTL is the preferred size for REQ_TYPE_FS requests as reported by the
device. The intent is to honor that. Your patch clamps the rw_size to
BLK_DEF_MAX_SECTORS which is not correct.

Ming> Also it is ugly to set limits->max_sectors from drivers directly,
Ming> and drivers should have called block helpers to do that.

We're trying to avoid unnecessary accessor functions for the queue
limits. But I will add a sanity check for the page size. And fix up
scsi_debug.

-- 
Martin K. Petersen	Oracle Linux Engineering
