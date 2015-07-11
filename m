From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] scsi_dh: Update EMC handler
Date: Sun, 12 Jul 2015 01:14:38 +0300
Message-ID: <20150711221438.GA20058@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41831 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbbGKWOw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2015 18:14:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org

Hello Hannes Reinecke,

The patch b6ff1b14cdf4: "[SCSI] scsi_dh: Update EMC handler" from Jul
17, 2008, leads to the following static checker warning:

	drivers/scsi/device_handler/scsi_dh_emc.c:252 parse_sp_model()
	warn: buffer overflow 'buffer' 252 <= 255

drivers/scsi/device_handler/scsi_dh_emc.c
   217  static char * parse_sp_model(struct scsi_device *sdev, unsigned char *buffer)
   218  {
   219          unsigned char len = buffer[4] + 5;

The warning is simply because Smatch assumes that "len" can be up to 255
since it is a u8.  That is likely not a real concern but I think there
are some off by one errors.

   220          char *sp_model = NULL;
   221          unsigned char sp_len, serial_len;
   222  
   223          if (len < 160) {

These conditions seem off by one to me.  If len == 160 then we can read
up to buffer[159]?  I think this should be:

		if (len < 161).

   224                  sdev_printk(KERN_WARNING, sdev,
   225                              "%s: Invalid information section length %d\n",
   226                              CLARIION_NAME, len);
   227                  /* Check for old FC arrays */
   228                  if (!strncmp(buffer + 8, "DGC", 3)) {
   229                          /* Old FC array, not supporting extended information */
   230                          sp_model = emc_default_str;
   231                  }
   232                  goto out;
   233          }
   234  
   235          /*
   236           * Parse extended information for SP model number
   237           */
   238          serial_len = buffer[160];
   239          if (serial_len == 0 || serial_len + 161 > len) {

Here the > should probably be >=.

   240                  sdev_printk(KERN_WARNING, sdev,
   241                              "%s: Invalid array serial number length %d\n",
   242                              CLARIION_NAME, serial_len);
   243                  goto out;
   244          }
   245          sp_len = buffer[99];
   246          if (sp_len == 0 || serial_len + sp_len + 161 > len) {

And here as well.

   247                  sdev_printk(KERN_WARNING, sdev,
   248                              "%s: Invalid model number length %d\n",
   249                              CLARIION_NAME, sp_len);
   250                  goto out;
   251          }
   252          sp_model = &buffer[serial_len + 161];


Otherwise we are potetially reading from &buffer[len] here which looks
off by one.

   253          /* Strip whitespace at the end */
   254          while (sp_len > 1 && sp_model[sp_len - 1] == ' ')
   255                  sp_len--;
   256  
   257          sp_model[sp_len] = '\0';
   258  
   259  out:
   260          return sp_model;
   261  }

regards,
dan carpenter
