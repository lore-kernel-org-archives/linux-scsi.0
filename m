From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: Check that the firmware loader is present in
	sas_request_addr
Date: Thu, 06 Mar 2008 15:17:13 -0600
Message-ID: <1204838233.3062.53.camel@localhost.localdomain>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com>
	 <20080306181645.GA6046@kroah.com> <47D03666.9080000@oracle.com>
	 <20080306210212.GC7430@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45095 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbYCFVRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 16:17:17 -0500
In-Reply-To: <20080306210212.GC7430@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>, linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

On Thu, 2008-03-06 at 13:02 -0800, Darrick J. Wong wrote:
> Return an error code in sas_request_addr if the fw loader isn't
> configured.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/libsas/sas_scsi_host.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 601ec5b..e44be7a 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -1085,6 +1085,7 @@ static void sas_parse_addr(u8 *sas_addr, const char *p)
>  
>  int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
>  {
> +#ifdef CONFIG_FW_LOADER
>  	int res;
>  	const struct firmware *fw;
>  
> @@ -1102,6 +1103,9 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
>  out:
>  	release_firmware(fw);
>  	return res;
> +#else
> +	return -ENOENT;
> +#endif
>  }
>  EXPORT_SYMBOL_GPL(sas_request_addr);

We could do it that way ... I suspect what Greg was asking for was more
like this:

James

---

diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 33d8f20..4d10c73 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -10,7 +10,10 @@ struct firmware {
 	size_t size;
 	u8 *data;
 };
+
 struct device;
+
+#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(
@@ -19,4 +22,24 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 
 void release_firmware(const struct firmware *fw);
+#else
+static inline int request_firmware(const struct firmware **fw,
+				   const char *name,
+				   struct device *device)
+{
+	return -EINVAL;
+}
+static inline int request_firmware_nowait(
+	struct module *module, int uevent,
+	const char *name, struct device *device, void *context,
+	void (*cont)(const struct firmware *fw, void *context))
+{
+	return -EINVAL;
+}
+
+static inline void release_firmware(const struct firmware *fw)
+{
+}
+#endif
+
 #endif


