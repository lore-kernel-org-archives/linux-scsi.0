Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890CD548F1;
	Thu,  4 Apr 2024 06:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.252.227.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712213747; cv=none; b=WVe6mGnKWeMBbD7hLvgdRrhCaPyt/je20uD8ywI0Tb18LpamjGTx3r/HEY/ODaxb42fJWiQ9QATcx1ndUHcoD65rznhZXEVt0e7D+sIswZQGUi6va6KJwF438vXvK44KPqxsxiPDR5OqeHoGCGyNtJfjknlAxb/yokFsBvqeMQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712213747; c=relaxed/simple;
	bh=/TkSoJVhwN0sFa9XmDOyKapqxmji/XCgpaNo1YUh5MY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mCJvKHxDN1aHR6zo+atl4zoelFhmX+AoCPkzobgkIv1tjz4iGrzzVk7Suy8yNkMcBnoiH/MNtgMnF+CaOyx2vrKoTzjVgXAJYRrDyDvTPdWQdF+0DdbgWwko0w/NhDtKuZypmWrq774H5WgRbSfP1O8mUDVbvD/PE0lsihrpTBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de; spf=pass smtp.mailfrom=wetzel-home.de; dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b=mhkEJjAi; arc=none smtp.client-ip=5.252.227.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="mhkEJjAi"
Message-ID: <5cbb1668-1640-4a5d-b6a8-ed0e5840b9ee@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
	s=wetzel-home; t=1712213733;
	bh=/TkSoJVhwN0sFa9XmDOyKapqxmji/XCgpaNo1YUh5MY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mhkEJjAi8tugEdCRcm1yf39ytSuvVtyOezlR1jntHq0B2m3i9GCfRSh9RxMW7cYJd
	 3tvtox0qhFFoCV6B0QP4LrVGHYgQfF/sD3Qt+EW2KbhI6VvI8pBhvxgufc7BKLK94h
	 O+vHqg0FV/kBEnDV7hbd4ggD2HVFOYxuq6NVZATY=
Date: Thu, 4 Apr 2024 08:55:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sg: Avoid race in error handling & drop bogus
 warn
To: Bart Van Assche <bvanassche@acm.org>, dgilbert@interlog.com
Cc: gregkh@linuxfoundation.org, sachinp@linux.ibm.com,
 linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 martin.petersen@oracle.com, stable@vger.kernel.org
References: <81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com>
 <20240401191038.18359-1-Alexander@wetzel-home.de>
 <bc800bdd-6563-40ba-bc8d-e98b87748c15@acm.org>
Content-Language: en-US, de-DE
From: Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <bc800bdd-6563-40ba-bc8d-e98b87748c15@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 04.04.24 01:24, Bart Van Assche wrote:
> On 4/1/24 12:10 PM, Alexander Wetzel wrote:
>> @@ -301,11 +302,12 @@ sg_open(struct inode *inode, struct file *filp)
>>       /* This driver's module count bumped by fops_get in <linux/fs.h> */
>>       /* Prevent the device driver from vanishing while we sleep */
>> -    retval = scsi_device_get(sdp->device);
>> +    device = sdp->device;
>> +    retval = scsi_device_get(device);
>>       if (retval)
>>           goto sg_put;
> 
> Are all the sdp->device -> device changes essential? Isn't there a
> preference to minimize patches that will end up in the stable trees?
> 

Only the very last change is essential:
-       scsi_device_put(sdp->device);
-       goto sg_put;
+       kref_put(&sdp->d_ref, sg_device_destroy);
+       scsi_device_put(device);
+       return retval;

Not using a (required) local variable and de-referencing it again and 
looks strange for anyone reading the code. While the additional lines in 
the patch are trivial to review...

Alexander
