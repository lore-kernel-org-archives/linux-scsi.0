From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Inquiry data and emulated SG devices
Date: Thu, 18 Oct 2007 06:06:37 -0400
Message-ID: <4717302D.4050107@garzik.org>
References: <fa.PgEHbZ0E5ogcX8bZwvrUeZB+eJs@ifi.uio.no>	 <4716B56A.1090501@shaw.ca>  <4716B786.80804@garzik.org> <1192701555.3247.28.camel@de-c-l-110.nero-de.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1192701555.3247.28.camel@de-c-l-110.nero-de.internal>
Sender: linux-ide-owner@vger.kernel.org
To: Mathieu Fluhr <mfluhr@nero.com>
Cc: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>, ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mathieu Fluhr wrote:
> On Wed, 2007-10-17 at 21:31 -0400, Jeff Garzik wrote:
>> Robert Hancock wrote:
>>> This doesn't seem a very reliable way to identify an IDE device, as all
>>> that 0 means is that the device does not claim conformance to any
>>> standard. I would think it would be legitimate for an IDE device to put
>>> a value like 5 in there as well, if it complies with SPC-4..
>> Via the this-doesnt-really-matter-but-it-should-be-noted department:
>>
>> According to the latest on t10.org, MMC retroactively permitted SCSI 
>> version to be zero, for MMC-compliant USB and ATAPI devices.
>>
> 
> Quoting to the latest MtFuji draft (Section 17.7.1):
>  "The ANSI Version field shall contain a non-zero value to comply with 
>   this version of the Specification for a SCSI logical unit or zero for
>   an ATAPI logical unit."
> 
> 
>>> In the case of libata though, that appears to be due to this code in
>>> drivers/ata/libata-scsi.c:
>>>
>>>     /* ATAPI devices typically report zero for their SCSI version,
>>>      * and sometimes deviate from the spec WRT response data
>>>      * format.  If SCSI version is reported as zero like normal,
>>>      * then we make the following fixups:  1) Fake MMC-5 version,
>>>      * to indicate to the Linux scsi midlayer this is a modern
>>>      * device.  2) Ensure response data format / ATAPI information
>>>      * are always correct.
>>>      */
>>>             if (buf[2] == 0) {
>>>                 buf[2] = 0x5;
>>>                 buf[3] = 0x32;
>>>             }
>>>
> 
> This explain a lot... But (Sorry I am not a scsi mid-layer expert) why
> faking what the device outputs?

The SCSI midlayer makes a lot of "if scsi version <= 2" choices.  In the 
case of ATAPI, we do not want to force ATAPI down the path of ancient 
SCSI devices, as this disables some MMC features that modern ATAPI 
devices support.

	Jeff



