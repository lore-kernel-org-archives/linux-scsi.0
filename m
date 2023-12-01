Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 8960A10E2;
	Thu, 30 Nov 2023 17:27:04 -0800 (PST)
Received: from [172.30.11.106] (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id 04889605E83EA;
	Fri,  1 Dec 2023 09:26:44 +0800 (CST)
Message-ID: <0247c807-333a-0e8c-d7ca-60e142ab6279@nfschina.com>
Date: Fri, 1 Dec 2023 09:26:44 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] scsi: aic7xxx: fix some problem of return value
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
In-Reply-To: <1784b008-6eb2-4dc8-ae21-b0b2c18760bf@suswa.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2023/11/30 15:21, Dan Carpenter wrote:
> On Thu, Nov 30, 2023 at 10:41:23AM +0800, Su Hui wrote:
>>   	error = aic7770_config(ahc, aic7770_ident_table + edev->id.driver_data,
>>   			       eisaBase);
>>   	if (error != 0) {
>>   		ahc->bsh.ioport = 0;
>>   		ahc_free(ahc);
>> -		return (error);
>> +		return -error;
> aic7770_config() mostly returns positive error codes but I see it also
> return -1 from ahc_reset().  So you'd want to do something like:
>
> 	return error < 0 ? error : -error;
Oh, I missed this one. Thanks for pointing out this mistake!
>> @@ -1117,7 +1117,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
>>   	if (retval) {
>>   		printk(KERN_WARNING "aic7xxx: scsi_add_host failed\n");
>>   		scsi_host_put(host);
>> -		return retval;
>> +		return -retval;
> Originally ahc_linux_register_host() returned a mix of positive and
> negative error codes.  You have converted it to return only positive
> error codes.  That's good for consistency in a way, but it's a step
> backwards from the big picture point of view.
Agreed, it's better to let ahc_linux_register_host() only return 
negative error codes.
>>   	}
>>   
>>   	scsi_scan_host(host);
>> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
>> index a07e94fac673..e17eb8df12c4 100644
>> --- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
>> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
>> @@ -241,8 +241,8 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   		ahc_linux_pci_inherit_flags(ahc);
>>   
>>   	pci_set_drvdata(pdev, ahc);
>> -	ahc_linux_register_host(ahc, &aic7xxx_driver_template);
>> -	return (0);
>> +	error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
>> +	return -error;
> This should be done in a separate patch.
>
> patch 1: return negative error codes in ahc_linux_register_host()
> patch 2: return negative error codes in aic7770_probe()
> patch 3: add a check for errors in ahc_linux_pci_dev_probe()

Got it, I will send v2 patch set soon.
Really thanks for your suggestions!

Su Hui

