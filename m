From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: close hole in > 2T device rejection when
 !CONFIG_LBDAF
Date: Tue, 4 Apr 2017 23:54:55 +0000
Message-ID: <1491350095.12081.3.camel@sandisk.com>
References: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
         <1488211985.2656.1.camel@sandisk.com>
         <3a6783ec-200d-5df5-2e1e-756c7e8b7c22@digidescorp.com>
         <1488221849.2656.8.camel@sandisk.com> <yq1pogrvj9y.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:55777 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdDDXzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 19:55:00 -0400
In-Reply-To: <yq1pogrvj9y.fsf@oracle.com>
Content-Language: en-US
Content-ID: <B3170D8718D33F4CA1D2CA72FD770EA8@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "steve@digidescorp.com" <steve@digidescorp.com>, "steve.magnani@digidescorp.com" <steve.magnani@digidescorp.com>

On Tue, 2017-04-04 at 19:35 -0400, Martin K. Petersen wrote:
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index fb9b4d29af0b..6084c415c070 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2102,6 +2102,16 @@ static void read_capacity_error(struct scsi_disk *=
sdkp, struct scsi_device *sdp,
> =20
>  #define READ_CAPACITY_RETRIES_ON_RESET	10
> =20
> +static bool sd_addressable_capacity(u64 lba, unsigned int sector_size)
> +{
> +	u64 last_sector =3D lba + 1ULL << ilog2(sector_size) - 9;
> +
> +	if (sizeof(sector_t) =3D=3D 4 && last_sector > 0xffffffffULL)
> +		return false;
> +
> +	return true;
> +}

Hello Martin,

How about replacing 0xffffffffULL with U32_MAX, adding parentheses in the
last_sector computation to make clear that + and - have precedence over <<
and adding a comment above=A0sd_addressable_capacity() that explains its
purpose and also that the shift operation must not be replaced with a call
to logical_to_sectors()? Otherwise this patch looks fine to me.

Thanks,

Bart.
