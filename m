From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 08/15] scsi_transport_srp: Add transport layer error
 handling
Date: Mon, 01 Jul 2013 09:01:21 +0200
Message-ID: <51D12941.3050105@acm.org>
References: <51CD856A.3010102@acm.org> <51CD873E.6040208@acm.org> <1372626334.12468.34.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372626334.12468.34.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/30/13 23:05, David Dillow wrote:
> On Fri, 2013-06-28 at 14:53 +0200, Bart Van Assche wrote:
>> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
>> +{
>> +	return (fast_io_fail_tmo < 0 || dev_loss_tmo < 0 ||
>> +		fast_io_fail_tmo < dev_loss_tmo) &&
>> +		fast_io_fail_tmo < LONG_MAX / HZ &&
>> +		dev_loss_tmo < LONG_MAX / HZ ? 0 : -EINVAL;
>> +}
>
> They should also be capped by SCSI_DEVICE_BLOCK_MAX_TIMEOUT instead of
> LONG_MAX / HZ, I think.

The fast_io_fail_tmo should indeed be capped by that value. However, I'm 
not sure about dev_loss_tmo. I think there are several use cases (e.g. 
initiator-side mirroring) where it's useful to set dev_loss_tmo to a 
larger value than ten minutes.

>> +static ssize_t store_srp_rport_fast_io_fail_tmo(struct device *dev,
>> +						struct device_attribute *attr,
>> +						const char *buf, size_t count)
>> +{
>> +	struct srp_rport *rport = transport_class_to_srp_rport(dev);
>> +	char ch[16], *p;
>> +	int res;
>> +	int fast_io_fail_tmo;
>> +
>> +	sprintf(ch, "%.*s", min_t(int, sizeof(ch) - 1, count), buf);
>> +	p = strchr(ch, '\n');
>> +	if (p)
>> +		*p = '\0';
>
> Again, no need for the sprintf if you don't modify the buffer? Instead
> of using strchr() to make the strcmp() work with newlines, just do
>
> if (!strcmp(buf, "off") || !strcmp(buf, "off\n")) {
> 	fast_io_fail_tmo = 1;
> } else {
> 	res = kstrtoint(buf, 0, &fast_io_fail_tmo);
> ...
>
> instead?
>
> Same comment applies for store_srp_rport_dev_loss_tmo().

OK, will remove the temporary char arrays.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
