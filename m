From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/5 v2] firewire: fw-sbp2: use sdev->hostdata
Date: Mon, 18 Jun 2007 19:08:31 +0200 (CEST)
Message-ID: <tkrat.c78a7eb1483e40b6@s5r6.in-berlin.de>
References: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
	<tkrat.86a8cf28dc784b39@s5r6.in-berlin.de>
	<1182180417.7928.13.camel@hinata.boston.redhat.com>
	<4676B3FD.9010604@s5r6.in-berlin.de>
	<tkrat.301a907417598815@s5r6.in-berlin.de>
	<tkrat.a1e99d6be46bde93@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.a1e99d6be46bde93@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I wrote:
...
> -	retval = scsi_add_device(host, 0, 0, lun);
> -	if (retval < 0) {
> +	sdev = __scsi_add_device(host, 0, 0, lun, sd);
> +	if (IS_ERR(sdev)) {

We could also stick with scsi_add_device here, omit also the rest of
thechanges to sbp2_login(), and set sdev->hostdata later in slave_alloc
instead.  But then...

...
>  static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
>  {
> -	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
> +	struct sbp2_device *sd = sdev->hostdata;
>  
>  	sdev->allow_restart = 1;

...we would have to keep the old expression here.  However, sd can't be
embedded into the shost anymore if we want multiple LUs beneath one
shost.

However, if you like I could retain this patch for now and resend it as
part of a multi-LU patch series.
-- 
Stefan Richter
-=====-=-=== -==- =--=-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
