Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26CC17559
	for <linux-scsi@vger.kernel.org>; Wed,  7 Feb 2024 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707303301; cv=none; b=HD8xJZbtODNJ5UWBA9CbvM8SFOsMee3/Ufo0UFIKLSVZPIA7RvcxiLpR0yIYx8kjb2EqdBtcoJ3+5nMt9fwLGhtJHa6fPh6MdK+n+0o48TmZxxU+OdoxFLJSawuzs2vJp83Hz0Y8uJVGBGNPKpFUKjwxXY736XvYIX4TJ8ruWvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707303301; c=relaxed/simple;
	bh=e4fmaDqWMhnJ82sNuWoq2ZujrDt92CW0laac1DIL6v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WlfSp6SentgmvWkvuWnkLMs+b2mdos/6TkfrB2xg6/54WtJvu5n+ePkPNwttM2HW3mkYIaiTEEL+Ucl0VKI9y7KK+Hlvr67hmnKXGwS0tiR9Z4YeRyN7xV2xDagS9YsCLdyUcXvo+wvPoKWGrkDElAL9IH1OuxdgVPPSNZEA0j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NEVVRL0X; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NEVVRL0X"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 417AbKK8011762;
	Wed, 7 Feb 2024 10:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nx0nXQmjR0sEX0ydvAQ81i3sU1PolYGk6jcwdikkVh0=;
 b=NEVVRL0XwOZcJWWyJJYLqlIP/uHPphAW8B8gL99RyEHfD7A0YiJpZHWXDLMp8suPTz8/
 JwXMEuC4NSH/P8rIgWJIgeTQVNUbJCDUUxEZJxB8LK58dspgWBymhJOzHGQLfqSYRsJZ
 yeBnZMYTMULUkiwD/NZQjo+mYGosLj1QPyK1E1i2ehDuZHoPe99OXS/F0LexfVa/gJy+
 xPhgXQvWXJlfMQmWkQWRWD6eBlByOGJoOs755xbGLHQ817L6jCeZtfJeAc/fvgNbDtL/
 UT5QbTTPvPzXHXAOfKacqAiXWOKmZ0ufex4dDfPt2gRNdi8ZYm0u2mcAaCPsS3FO9hWk NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4890gd7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 10:54:55 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 417Aofgw013687;
	Wed, 7 Feb 2024 10:54:55 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4890gd6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 10:54:55 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41789U7l005756;
	Wed, 7 Feb 2024 10:54:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w21akn2cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 10:54:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 417AspEB22020786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Feb 2024 10:54:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 211BA20043;
	Wed,  7 Feb 2024 10:54:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CF2320040;
	Wed,  7 Feb 2024 10:54:51 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.82.240])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  7 Feb 2024 10:54:51 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.97.1)
	(envelope-from <bblock@linux.ibm.com>)
	id 1rXfZq-00000000hHX-2TXR;
	Wed, 07 Feb 2024 11:54:50 +0100
Date: Wed, 7 Feb 2024 11:54:50 +0100
From: Benjamin Block <bblock@linux.ibm.com>
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: fix sd ida memory leak
Message-ID: <20240207105450.GA16886@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20240129090234.7762-1-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240129090234.7762-1-kanie@linux.alibaba.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jVJuhrtA8j-H5LsEJyxUOus7hmWEdBIx
X-Proofpoint-ORIG-GUID: HDB8Hmmwk_UVvShJnf9rCg9BLdogoToc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-07_04,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402070081

On Mon, Jan 29, 2024 at 05:02:34PM +0800, Guixin Liu wrote:
> The sd_index_ida should be destroy when the sd module exit.
> 
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>  drivers/scsi/sd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 0833b3e6aa6e..8b88cba88da2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4079,6 +4079,8 @@ static void __exit exit_sd(void)
>  
>  	for (i = 0; i < SD_MAJORS; i++)
>  		unregister_blkdev(sd_major(i), "sd");
> +
> +	ida_destroy(&sd_index_ida);

Looks good to me.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
