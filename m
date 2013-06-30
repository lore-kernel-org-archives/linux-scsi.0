From: David Dillow <dave@thedillows.org>
Subject: Re: [PATCH v2 08/15] scsi_transport_srp: Add transport layer error
 handling
Date: Sun, 30 Jun 2013 17:05:34 -0400
Message-ID: <1372626334.12468.34.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD873E.6040208@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:51135 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3F3VGi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jun 2013 17:06:38 -0400
In-Reply-To: <51CD873E.6040208@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On Fri, 2013-06-28 at 14:53 +0200, Bart Van Assche wrote:
> Add the necessary functions in the SRP transport module to allow
> an SRP initiator driver to implement transport layer error handling
> similar to the functionality already provided by the FC transport
> layer. This includes:
> - Support for implementing fast_io_fail_tmo, the time that should
>   elapse after having detected a transport layer problem and
>   before failing I/O.
> - Support for implementing dev_loss_tmo, the time that should
>   elapse after having detected a transport layer problem and
>   before removing a remote port.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Roland Dreier <roland@purestorage.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: David Dillow <dillowda@ornl.gov>
> Cc: Vu Pham <vu@mellanox.com>
> Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> ---
>  Documentation/ABI/stable/sysfs-transport-srp |   37 ++
>  drivers/scsi/scsi_transport_srp.c            |  477 +++++++++++++++++++++++++-
>  include/scsi/scsi_transport_srp.h            |   62 +++-
>  3 files changed, 573 insertions(+), 3 deletions(-)

> +/**
> + * srp_tmo_valid() - check timeout combination validity
> + *
> + * If both a fast I/O fail and a device loss timeout have been configured then
> + * the fast I/O fail timeout must be below the device loss timeout.
> + */
> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
> +{
> +	return (fast_io_fail_tmo < 0 || dev_loss_tmo < 0 ||
> +		fast_io_fail_tmo < dev_loss_tmo) &&
> +		fast_io_fail_tmo < LONG_MAX / HZ &&
> +		dev_loss_tmo < LONG_MAX / HZ ? 0 : -EINVAL;
> +}

There's really no need to fit it in one line to save space -- it makes
it much easier to read if you unpack it and return -EINVAL for the
problem cases.

They should also be capped by SCSI_DEVICE_BLOCK_MAX_TIMEOUT instead of
LONG_MAX / HZ, I think.


> +static ssize_t store_reconnect_delay(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, const size_t count)
> +{
> +	struct srp_rport *rport = transport_class_to_srp_rport(dev);
> +	char ch[16];
> +	int res, delay;
> +
> +	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
> +	res = kstrtoint(ch, 0, &delay);
> +	if (res)
> +		goto out;

I don't see the need for the sprintf? kstrtoint() will give you -ERANGE
if the value doesn't fit in an int...

Ah, NULL terminated string... except sysfs guarantees this for us for
the store method -- see fill_write_buffer() in fs/sysfs.c.

> +static ssize_t store_srp_rport_fast_io_fail_tmo(struct device *dev,
> +						struct device_attribute *attr,
> +						const char *buf, size_t count)
> +{
> +	struct srp_rport *rport = transport_class_to_srp_rport(dev);
> +	char ch[16], *p;
> +	int res;
> +	int fast_io_fail_tmo;
> +
> +	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
> +	p = strchr(ch, '\n');
> +	if (p)
> +		*p = '\0';

Again, no need for the sprintf if you don't modify the buffer? Instead
of using strchr() to make the strcmp() work with newlines, just do

if (!strcmp(buf, "off") || !strcmp(buf, "off\n")) {
	fast_io_fail_tmo = 1;
} else {
	res = kstrtoint(buf, 0, &fast_io_fail_tmo);
...

instead?

Same comment applies for store_srp_rport_dev_loss_tmo().

I haven't fully gone over the logic just yet, so I'm relying a bit on
Hannes and Mike's discussion from the last round. This looks to be
pretty reasonably sorted, though, based on the level of review I've been
able to do so far...


