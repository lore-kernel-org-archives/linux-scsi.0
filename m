From: Patrick Mansfield <patman@aracnet.com>
Subject: Re: [PATCH] /dev/disk/by-id incomplete and unhelpful for SATA drives
Date: Fri, 6 Jan 2006 11:46:52 -0800
Message-ID: <20060106194652.GB6404@aracnet.com>
References: <doc5jl$acv$1@sea.gmane.org> <20051221185518.GA9100@vrfy.org> <43A9CFE0.2070103@edesix.com> <20051222043527.GA13175@vrfy.org> <43AA8D0B.10504@edesix.com> <20051222183525.GA17871@devserv.devel.redhat.com> <43AB40E2.1050009@edesix.com> <20060106013640.GA27841@aracnet.com> <43BDDCAE.7000506@torque.net> <43BE6506.7090901@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <43BE6506.7090901@torque.net>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Douglas Gilbert <dougg@torque.net>
Cc: Chris Paulson-Ellis <chris@edesix.com>, Bill Nottingham <notting@redhat.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 06, 2006 at 10:39:34PM +1000, Douglas Gilbert wrote:

> Changelog:
>   - make existing libata VPD device identification page (0x83)
>     supply the ATA serial number in the libata "vendor
>     specific" designator (from Chris Paulson-Ellis)
>   - add a "t10 vendor id based" designator as defined in
>     SAT rev 07a (section 10.3.4.2.3) that supplies ATA
>     model and serial numbers

> --- linux/drivers/scsi/libata-scsi.c	2006-01-04 08:50:42.000000000 +1000
> +++ linux/drivers/scsi/libata-scsi.c2615vpd	2006-01-06 20:16:25.000000000 +1000

>  unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
>  			      unsigned int buflen)
>  {
> +	int num;
> +	const int sat_model_serial_desc_len = 68;
> +	const int ata_model_byte_len = 40;
> +
>  	rbuf[1] = 0x83;			/* this page code */
> -	rbuf[3] = 4 + strlen(inq_83_str);	/* page len */
> +	num = 4;
>  
> -	/* our one and only identification descriptor (vendor-specific) */
> -	if (buflen > (strlen(inq_83_str) + 4 + 4 - 1)) {
> -		rbuf[4 + 0] = 2;	/* code set: ASCII */
> -		rbuf[4 + 3] = strlen(inq_83_str);
> -		memcpy(rbuf + 4 + 4, inq_83_str, strlen(inq_83_str));
> +	if (buflen > (ATA_SERNO_LEN + num + 3)) {
> +		/* piv=0, assoc=lu, code_set=ACSII, designator=vendor */
> +		rbuf[num + 0] = 2;	
> +		rbuf[num + 3] = ATA_SERNO_LEN;
> +		num += 4;
> +		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
> +				  ATA_ID_SERNO_OFS, ATA_SERNO_LEN);
> +		num += ATA_SERNO_LEN;
>  	}
> -
> +	if (buflen > (sat_model_serial_desc_len + num + 3)) {
> +		/* SAT defined lu model and serial numbers descriptor */
> +		/* piv=0, assoc=lu, code_set=ACSII, designator=t10 vendor id */
> +		rbuf[num + 0] = 2;	
> +		rbuf[num + 1] = 1;	
> +		rbuf[num + 3] = sat_model_serial_desc_len;
> +		num += 4;
> +		strncpy(rbuf + num, "ATA     ", 8);
> +		num += 8;
> +		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
> +				  ATA_ID_PROD_OFS, ata_model_byte_len);
> +		num += ata_model_byte_len;
> +		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
> +				  ATA_ID_SERNO_OFS, ATA_SERNO_LEN);
> +		num += ATA_SERNO_LEN;
> +	}
> +	rbuf[3] = num - 4;    /* page len (assume less than 256 bytes) */


I was trying to figure out if we are guranteed will have unique values
across all ATA devices with Doug's patch. I am not familiar with ATA and
IDENTIFY DEVICE.

For page 0x83, Doug's change above gives us:

	ATA + 40 bytes of model/product (must have white space) + serial number

Under "10.3.4.2.3 Logical unit name derived from the model number and
serial number" the spec says:

	NOTE 9 The logical unit name using the T10 vendor identification
	format is not guaranteed to be worldwide unique, since ATA/ATAPI-7
	only requires the combination of the MODEL NUMBER field and SERIAL
	NUMBER field to be unique for a given manufacturer but defines no
	manufacturer identification field.

I don't know why they have this given the above. So it is possible (though
unlikely?) that model numbers will overlap, and so scsi_id values too?

If we put had an actual vendor in the sdev->vendor, we could use page 0x83
type 0 with no name collisions (if that vendor + model actually gives us
unique serial numbers). 

Why does the SAT translation spec have the vendor identification of ATA???

The "logical unit name derived from the world wide name" looks nicer, but I
assume not all vendors support that.

-- Patrick Mansfield


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
