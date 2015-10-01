From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 33/36] scsi: Add 'access_state' attribute
Date: Thu, 1 Oct 2015 16:04:22 -0700
Message-ID: <560DBBF6.4080802@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-34-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bbn0100.outbound.protection.outlook.com ([157.56.111.100]:37568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751115AbbJAXEa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 19:04:30 -0400
In-Reply-To: <1443523658-87622-34-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
> +static const struct {
> +	enum scsi_access_state	value;
> +	char			*name;

Had you considered to use "const char *" here instead of "char *" ?

> +const char *scsi_access_state_name(enum scsi_access_state state)
> +{
> +	int i;
> +	char *name = NULL;
> +
> +	for (i = 0; i < ARRAY_SIZE(sdev_access_states); i++) {
> +		if (sdev_access_states[i].value == state) {
> +			name = sdev_access_states[i].name;
> +			break;
> +		}
> +	}
> +	return name;
> +}

The return value of this function is passed without further processing 
to the format specifier "%s". How about initializing "name" to "(?)" to 
avoid that "(null)" is printed if the access state is not recognized ?

> +static ssize_t
> +sdev_show_access_state(struct device *dev,
> +		       struct device_attribute *attr,
> +		       char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	enum scsi_access_state access_state;
> +	bool pref = false;
> +
> +	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
> +		pref = true;
> +
> +	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
> +
> +	return snprintf(buf, 32, "%s%s\n",
> +			scsi_access_state_name(access_state),
> +			pref ? " preferred" :"");
> +}

Shouldn't this function check whether a device handler has been 
associated with sdev and also whether the active device handler is the 
ALUA device handler ? Otherwise incorrect data will be reported before 
the ALUA device handler has been loaded, after it has been unloaded or 
if another device handler is active.

Additionally, please insert a separator between the preferred state and 
the access state name. Had you considered to use PAGE_SIZE instead of 
"32" as output buffer length ? Magic constants in code always make the 
reader wonder where these come from ...

How about reporting the target port group ID next to the ALUA state ? I 
think that data would be very useful because it allows users to verify 
which LUNs have been associated with which port group by this patch series.

Thanks,

Bart.
