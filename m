Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FuAKoOZT"
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7A291;
	Thu, 23 Nov 2023 04:56:25 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ANCIDQa031579;
	Thu, 23 Nov 2023 12:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DQVPNWAVHATOwJ43a3rPhj1rzRAJZ4VgfHy4rm+zPeI=;
 b=FuAKoOZTBMLTqQmIdsRRVG8wEemVbDVEyvSUFU0Fwth0eIxbCreNAAzS0K/sd12h+Ypb
 TspDt1hAjHrOAvI3kcON8N3x+DA3EIx901N9Y63Xh24HSE6s6KsvK/pFbaVluMalJxQP
 yFSvLxcChEIlL2aSJATiv3gGlRDEq9Gw9uHyag/X83cO6NftGITO3yEGtCqNLW4Y5pp0
 VAtm34GiRAQduV0qqBIuBOt3IldTre44NuycaT4sDXRnl1aIxq3UCpVhWB/zISByZEhk
 ddWbcptrQXNtvbMEdH6mK7FLUDEt+K8q9RnniP3n7df/porL7O1KQIFbo7rZzUtT+BqP mg== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uj6ma0vda-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Nov 2023 12:56:10 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ANBIhU5022418;
	Thu, 23 Nov 2023 12:51:59 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uf7yyyawf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Nov 2023 12:51:59 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ANCpwH014680746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Nov 2023 12:51:59 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5D9158059;
	Thu, 23 Nov 2023 12:51:58 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B0C058057;
	Thu, 23 Nov 2023 12:51:56 +0000 (GMT)
Received: from [IPv6:2601:5c4:4302:c21::a774] (unknown [9.67.0.97])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Nov 2023 12:51:56 +0000 (GMT)
Message-ID: <d3ec8bb44e69f1dbc0a0cc31077b5a8e09a277ef.camel@linux.ibm.com>
Subject: Re: [PATCH v4] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
From: James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To: John Garry <john.g.garry@oracle.com>,
        Sagar Biradar
 <sagar.biradar@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        Gilbert
 Wu <gilbert.wu@microchip.com>, linux-scsi@vger.kernel.org,
        Martin Petersen
 <martin.petersen@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Tom White <tom.white@microchip.com>, regressions@leemhuis.info,
        hare@suse.com
Date: Thu, 23 Nov 2023 07:51:54 -0500
In-Reply-To: <c830058d-8d03-4da4-bdd4-0e56c567308f@oracle.com>
References: <20230519230834.27436-1-sagar.biradar@microchip.com>
	 <c830058d-8d03-4da4-bdd4-0e56c567308f@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0jdFhNeqTRlIFi1uF3zX_YQ3I0a_E5wB
X-Proofpoint-ORIG-GUID: 0jdFhNeqTRlIFi1uF3zX_YQ3I0a_E5wB
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-23_11,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=733
 malwarescore=0 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 mlxscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311230092

On Thu, 2023-11-23 at 12:01 +0000, John Garry wrote:
> On 20/05/2023 00:08, Sagar Biradar wrote:
> > Fix the IO hang that arises because of MSIx vector not
> > having a mapped online CPU upon receiving completion.
> > 
> > The SCSI cmds take the blk_mq route, which is setup during the
> > init. The reserved cmds fetch the vector_no from mq_map after the
> > init is complete and before the init, they use 0 - as per the norm.
> > 
> > Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
> > Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
> 
> This the patch which seems to be causing the issue in 
> https://bugzilla.kernel.org/show_bug.cgi?id=217599
> 
> I will comment here since I got no response there...

We can still do a clean revert of this commit if no other solution is
found before the end of the 6.7 rc cycle.

Regards,

James

