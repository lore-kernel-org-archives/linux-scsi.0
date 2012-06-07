From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 1/3] scsi: set to WCE if usb cache quirk is present.
Date: Thu, 7 Jun 2012 09:40:19 +0900
Message-ID: <CAKYAXd_T4DTB=FZFejf8hbpdRzeeXx5cybx56SNG6srCtRLRHQ@mail.gmail.com>
References: <1338985224-9684-1-git-send-email-linkinjeon@gmail.com>
	<Pine.LNX.4.44L0.1206061126280.1788-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1206061126280.1788-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James.Bottomley@hansenpartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Hi Alan.

I will send patch v2 after chaing code.
Thanks for your review.

2012/6/7, Alan Stern <stern@rowland.harvard.edu>:
> On Wed, 6 Jun 2012, Namjae Jeon wrote:
>
>> Make use of USB quirk method to identify such HDD while reading the cache
>> status in sd_probe(). If cache quirk is present for the HDD, lets assume
>> that cache is enabled and make WCE bit equal to 1.
>
> Your lines should be wrapped after 72 columns or so.
>
> Calling this a "quirk" sounds strange.  Really, your new flag indicates
> that WCE should default to "on" instead of "off".  How about calling it
> "wce_default_on" instead of "wce_quirk"?
>
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -152,6 +152,7 @@ struct scsi_device {
>>  	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
>>  	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
>>  	unsigned is_visible:1;	/* is the device visible in sysfs */
>> +	unsigned wce_quirk:1; /* cache read page is not available */
>
> The comment is wrong.  There's no need for a quirk to indicate the
> cache page is unavailable; the driver already knows when the page is
> unavailable.  Rather, the quirk indicates that WCE should default to
> "on".
>
> Alan Stern
>
>
