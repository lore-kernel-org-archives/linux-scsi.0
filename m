From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH V2 1/2] qedi: Fix truncation of CHAP name and secret
Date: Wed, 7 Feb 2018 13:15:54 +0000
Message-ID: <D6A0F797.289A3%nilesh.javali@cavium.com>
References: <20180206131219.18184-1-nilesh.javali@cavium.com>
 <20180206131219.18184-2-nilesh.javali@cavium.com>
 <1517930620.3934.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0072.outbound.protection.outlook.com ([104.47.37.72]:59424
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753497AbeBGNP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 08:15:56 -0500
In-Reply-To: <1517930620.3934.12.camel@wdc.com>
Content-Language: en-US
Content-ID: <96D490A15BD31F4B9514E64921229529@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "lduncan@suse.com" <lduncan@suse.com>, "cleech@redhat.com" <cleech@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>


On 2/6/18, 8:53 PM, "Bart Van Assche" <Bart.VanAssche@wdc.com> wrote:

>On Tue, 2018-02-06 at 05:12 -0800, Nilesh Javali wrote:
>> From: Andrew Vasquez <andrew.vasquez@cavium.com>
>>=20
>> The data in NVRAM is not guaranteed to be NUL terminated.
>> Copy the data upto the element size or to the first NUL
>> in the byte-stream and then append a NUL.
>>=20
>> Signed-off-by: Andrew Vasquez <andrew.vasquez@cavium.com>
>> Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
>> ---
>>  drivers/scsi/qedi/qedi_main.c | 45
>>+++++++++++++++++++++++++++++++------------
>>  1 file changed, 33 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/drivers/scsi/qedi/qedi_main.c
>>b/drivers/scsi/qedi/qedi_main.c
>> index 8808f0d..f3dd438 100644
>> --- a/drivers/scsi/qedi/qedi_main.c
>> +++ b/drivers/scsi/qedi/qedi_main.c
>> @@ -1705,6 +1705,27 @@ void qedi_reset_host_mtu(struct qedi_ctx *qedi,
>>u16 mtu)
>>  	qedi_ops->ll2->start(qedi->cdev, &params);
>>  }
>> =20
>> +static ssize_t
>> +qedi_show_copy_data(char *buf, size_t size, u8 *data)
>> +{
>> +	size_t i;
>> +
>> +	if (!data)
>> +		return sprintf(buf, "\n");
>> +
>> +	/*
>> +	 * Data not guaranteed to be NUL terminated. Copy until NUL found or
>> +	 * complete copy done.
>> +	 */
>> +	for (i =3D 0; i < size && data[i]; i++)
>> +		buf[i] =3D data[i];
>> +	/* Data copy complete, append NEWLINE and NUL terminator. */
>> +	buf[i] =3D '\n';
>> +	buf[i + 1] =3D '\0';
>> +	return strlen(buf);
>> +}
>
>Can the body of the above function be changed into the following, which
>is much
>shorter?
>
>sprintf(buf, "%.*s", (int)size, data ? : "")

This looks clean and shorter. I will send the updated patch.



Thanks,
Nilesh
