From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 15 Jun 2016 18:46:24 -0500
Message-ID: <C63F4DAA-89E6-400F-86EA-D55267848201@linux.vnet.ibm.com>
References: <1464409675.22249.237.camel@haakon3.risingtidesystems.com>
 <1465507614-29695-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <c5aa5fec-3499-a899-aa22-07c655311e20@sandisk.com>
 <1465886151.5365.220.camel@haakon3.risingtidesystems.com>
 <9e27fd8d-6e9e-6ec5-abb8-49e405143e48@sandisk.com>
 <20160614145728.GB18075@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39269 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752819AbcFOXqe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 19:46:34 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FNi7HA130361
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:46:33 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23jgmpf25m-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:46:33 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 17:46:32 -0600
In-Reply-To: <20160614145728.GB18075@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

On 6/14/16, 9:57 AM, "Christoph Hellwig" <hch@infradead.org> wrote:

>On Tue, Jun 14, 2016 at 10:46:09AM +0200, Bart Van Assche wrote:
>> All what's needed is something like the (untested) patch below. As o=
ne
>> can see no new function pointers have been added to target_core_fabr=
ic_ops.
>> All that has been added are a few new data members. With the patch b=
elow
>> ibmvscsis_modify_std_inquiry() can be left out and the target core w=
ill
>> pick up the "IBM", "VOPTA", "3303 NVDISK" and "0001" strings through=
 the
>> target_core_fabric_ops instance in the ibmvscsis template. I think t=
his is
>> a much cleaner approach than keeping the ibmvscsis_modify_std_inquir=
y()
>> function ...
>
>If we really have to, yes.  But then again we manually allow overridin=
g
>the values from configfs, and none of this seems to be a protocol
>requirement but just a workaround for a braindead AIX initiator.  So
>the right thing is documentation telling people how to modify their
>inquiry strings for AIX to work.
>

I can add documentation for modifying their inquiry strings, but the th=
ing is
This is just to support older AIX clients who don=E2=80=99t want to upd=
ate. We already
Have a working ODM patch to address this but we=E2=80=99d still like to=
 support older
Customers who would like to use this driver with an AIX initiator(clien=
t).

Latest patch I have stripped everything out as per your request, which
Does work with a linux client.

-Bryant


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
