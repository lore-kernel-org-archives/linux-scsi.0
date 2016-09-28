From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 6/7] sd: Implement support for ZBC devices
Date: Wed, 28 Sep 2016 01:01:04 -0400
Message-ID: <yq18tuczkhb.fsf@sermon.lab.mkp.net>
References: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
        <1475025757-6340-7-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1475025757-6340-7-git-send-email-damien.lemoal@hgst.com> (Damien
        Le Moal's message of "Wed, 28 Sep 2016 10:22:36 +0900")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Damien" == Damien Le Moal <damien.lemoal@hgst.com> writes:

Damien,

The new stuff looks much cleaner. Thanks for doing that!

This hunk has an unintended side effect:

@@ -2836,14 +2896,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, buffer);
-
 		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
 		}
 
+		sd_read_capacity(sdkp, buffer);
+
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);

LMBPE from READ CAPACITY(16) will not be set when calling
sd_read_block_provisioning() and thus we bail early (we catch it second
time around). You may want to split that vpd conditional to shuffle the
block_characteristics on top. Or even better: Split the capacity/block
size printing code from sd_read_capacity() into a separate function and
do:

	if (sdkp->media_present) {
		sd_read_capacity(sdkp, buffer);

		if (sd_try_extended_inquiry(sdp)) {
			sd_read_block_provisioning(sdkp);
			sd_read_block_limits(sdkp);
			sd_read_block_characteristics(sdkp);
		}

+               sd_print_capacity(sdkp);

		sd_read_write_protect_flag(sdkp, buffer);
		sd_read_cache_type(sdkp, buffer);
		sd_read_app_tag_own(sdkp, buffer);
		sd_read_write_same(sdkp, buffer);
	}

Typo:

static int sd_zbc_read_zoned_charateristics(struct scsi_disk *sdkp,
                             ^^^^^^^^^^^^^^

My second comment is that I don't particularly like the notion of values
being stored and passed in units of block layer sectors in struct
scsi_disk and sd*.  As a rule of thumb I prefer SCSI stuff to be counted
in logical blocks and block layer stuff in 512b sectors. You may want to
entertain having a sectors_to_zone() wrapper to facilitate that
conversion.

-- 
Martin K. Petersen	Oracle Linux Engineering
