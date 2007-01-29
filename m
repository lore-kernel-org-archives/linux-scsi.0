From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH RFC] sd: spin down disks on removal or power-down
Date: Mon, 29 Jan 2007 17:55:41 -0600
Message-ID: <45BE897D.7000400@shaw.ca>
References: <45BD522F.3070706@shaw.ca> <20070129154706.dfb3edab.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <20070129154706.dfb3edab.akpm@osdl.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> triviata:
> 
>> --- linux-2.6.20-rc6nv/drivers/scsi/sd.c	2007-01-28 17:00:00.000000000 -0600
>> +++ linux-2.6.20-rc6nvedit/drivers/scsi/sd.c	2007-01-28 18:08:53.000000000 -0600
>> @@ -821,6 +821,39 @@ static int sd_sync_cache(struct scsi_dev
>>  	return res;
>>  }
>>  
>> +static int sd_stop_unit(struct scsi_device *sdp, struct scsi_disk* sdkp)
> 
> s/* / */
> 
>> +{
>> +	int res;
>> +	struct scsi_sense_hdr sshdr;
>> +	unsigned char cmd[10] = { 0 };
> 
> I don't think this initialisation-to-all-zeroes is needed, is it?

Pretty sure it is, the rest of the command needs to be set to 0. Without 
it the other 9 bytes will contain uninitialized junk.

For the other cleanup changes, though:

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/



