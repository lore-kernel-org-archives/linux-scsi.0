From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [PATCH] Add attributes to FC transport
Date: Tue, 10 Aug 2004 09:25:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EEFB@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:18616 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S267503AbUHJQ2t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 12:28:49 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "Rajan, Mukesh" <Mukesh.Rajan@Emulex.Com>
Cc: brking@us.ibm.com, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com


On Friday, August 06, 2004 1:47 PM, Rajan, Mukesh wrote:
> 
> We would like to export certain HBA attributes such as Port Type,
> Port Speed etc via sysfs in the lpfc driver. These attributes are
> more representative of the transport layer and it will benefit from
> including them as generic FC transport attributes. Also the patch
> corrects the illegal values of node_name, port_name and port_id to
> zero, which are the accepted NULL values as per the FC-GS-4
> standards.
> 

Quick comment: your mailer appears to have mangled the patch.

Overall, ooks good.  If we are going to model the transport attributes
upon the FC-HBA spec., then perhaps the following changes should be
made:

> ...
> +	if (tp->port_supported_classes & FCHBA_COS_CLASS1)
> +		len += sprintf(buf, "o Class 1\n");
> +	if (tp->port_supported_classes & FCHBA_COS_CLASS2)
> +		len += sprintf(buf+len, "o Class 2\n");
> +	if (tp->port_supported_classes & FCHBA_COS_CLASS3)
> +		len += sprintf(buf+len, "o Class 3\n");
> +

Add support for Class F, 4 and 6.

> ...
> +	for (j = 0; j < 32; j++)
> +		len += sprintf(buf+len , "%x ", tp->port_active_fc4types[j]);
> +

	len += sprintf(buf+len , "%02x ", tp->port_active_fc4types[j]);

would be clearer.

> ...
>
> +#define FCHBA_COS_CLASS1	1   /* CLASS 1 */
> +#define FCHBA_COS_CLASS2	2   /* CLASS 2 */
> +#define FCHBA_COS_CLASS3	4   /* CLASS 3 */
> +

The following would more closely model the COS format as defined in
FC-GS-4:

	#define FCHBA_COS_CLASSF	1   /* CLASS F */
	#define FCHBA_COS_CLASS1	2   /* CLASS 1 */
	#define FCHBA_COS_CLASS2	4   /* CLASS 2 */
	#define FCHBA_COS_CLASS3	8   /* CLASS 3 */
	#define FCHBA_COS_CLASS4	0x10   /* CLASS 4 */
	#define FCHBA_COS_CLASS6	0x40   /* CLASS 6 */

and save the drivers from having to convert GCS_ID data to
fc_transport values.

> +#define FCHBA_PORTSPEED_4GBIT		8   /* 4 GBit/sec */
> +#define FCHBA_PORTSPEED_NOT_NEGOTIATED	5   /* Speed
> not established */

FC-HBA defines this not-negotiated state as:

	#define FCHBA_PORTSPEED_NOT_NEGOTIATED	(1 << 15)


--
Andrew
