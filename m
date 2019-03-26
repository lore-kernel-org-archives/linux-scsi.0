From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: ses: fix some risks of out of bound access
Date: Tue, 26 Mar 2019 09:06:09 -0400
Message-ID: <bc247133bb00ef1f00dd0757c6d84d315cab1bbc.camel@redhat.com>
References: <1553499602-27810-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553499602-27810-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

See below.

On Mon, 2019-03-25 at 15:40 +0800, Jianchao Wang wrote:
> We have some places with risk of accessing out of bound of the
> buffer allocated from slab, even it could corrupt the memory.
> 
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> ---
>  drivers/scsi/ses.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 0fc3922..42e6a1f 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -520,6 +520,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
>  	struct ses_device *ses_dev = edev->scratch;
>  	int types = ses_dev->page1_num_types;
>  	unsigned char *hdr_buf = kzalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
> +	unsigned char *page1_end = ses_dev->page1 + ses_dev->page1_len;
>  
>  	if (!hdr_buf)
>  		goto simple_populate;
> @@ -556,6 +557,11 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
>  	type_ptr = ses_dev->page1_types;
>  	components = 0;
>  	for (i = 0; i < types; i++, type_ptr += 4) {
> +		if (type_ptr > page1_end - 2) {

I think "if (type_ptr + 1 >= page1_end)" would be more consistent.

> +			sdev_printk(KERN_ERR, sdev, "Access out of bound of page1"
> +					"%p page1_end %p\n", page1_end, type_ptr);

This message is not helpful for someone with a device reporting
invalid enclosure data.  It should be more generic, like
"Enclosure data too short" or "invalid" or something.  And, the
actual pointer values are irrelevant, it all depends upon the
contents of the buffer.

> +			break;
> +		}
>  		for (j = 0; j < type_ptr[1]; j++) {
>  			char *name = NULL;
>  			struct enclosure_component *ecomp;
> @@ -566,10 +572,15 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
>  				} else {
>  					len = (desc_ptr[2] << 8) + desc_ptr[3];
>  					desc_ptr += 4;
> -					/* Add trailing zero - pushes into
> -					 * reserved space */
> -					desc_ptr[len] = '\0';
> -					name = desc_ptr;
> +					if (desc_ptr + len >= buf + page7_len) {
> +						desc_ptr = NULL;
> +					} else {
> +
> +						/* Add trailing zero - pushes into
> +						 * reserved space */
> +						desc_ptr[len] = '\0';
> +						name = desc_ptr;
> +					}
>  				}
>  			}
>  			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
> @@ -693,7 +704,13 @@ static int ses_intf_add(struct device *cdev,
>  	/* begin at the enclosure descriptor */
>  	type_ptr = buf + 8;
>  	/* skip all the enclosure descriptors */
> -	for (i = 0; i < num_enclosures && type_ptr < buf + len; i++) {
> +	for (i = 0; i < num_enclosures; i++) {
> +		if (type_ptr >= buf + len) {
> +			sdev_printk(KERN_ERR, sdev, "Overflow the buf len = %d\n", len);

See above, the message is unhelpful.  The actual problem is that
the Enclosure data is too short or invalid.

> +			err = -EINVAL;
> +			goto err_free;
> +		}
> +
>  		types += type_ptr[2];
>  		type_ptr += type_ptr[3] + 4;
>  	}

This will still potentially leave type_ptr past the end of the
buffer in the subsequent code, though, right?

This might fix the problem for your malfunctioning device, but
does not look like it would handle the general case.

-Ewan
