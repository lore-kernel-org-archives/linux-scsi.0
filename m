From: Masthan <d.mastan@gmail.com>
Subject: program inquiry is using a deprecated scsi_ioctl , please convert
 it to SG_IO
Date: Thu, 8 Feb 2007 02:14:02 -0800 (PST)
Message-ID: <8862659.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:32895 "EHLO talk.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423153AbXBHKOH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Feb 2007 05:14:07 -0500
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1HF6Hy-0003Xw-4u
	for linux-scsi@vger.kernel.org; Thu, 08 Feb 2007 02:14:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi All,

I am not getting why i am getting the following DIAG message

Program inquiry is using deprecated scsi ioctl, please convert it to SG_IO.

The following snippet of linux source code clearly saying that, the above
message is a kind of cosmetic warning message.

Do you know how to use SG_IO to overcome this problem.

The following function sayign that only 6 scsi ioctls are deprecated, out of
6 inquiry program is using  only 2 scsi ioctls(i.e.SCSI_IOCTL_SEND_COMMAND
and SCSI_IOCTL_TEST_UNIT_READY ) . What are their equivalents SG_IO ioctls ?



181  /* the scsi_ioctl() function differs from most ioctls in that it does
182  * not take a major/minor number as the dev field.  Rather, it takes
183  * a pointer to a scsi_devices[] element, a structure. 
184  */
185 int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
186 {
187         char scsi_cmd[MAX_COMMAND_SIZE];
188 
189         /* No idea how this happens.... */
190         if (!sdev)
191                 return -ENXIO;
192 
193         /*
194          * If we are in the middle of error recovery, don't let anyone
195          * else try and use this device.  Also, if error recovery fails,
it
196          * may try and take the device offline, in which case all
further
197          * access to the device is prohibited.
198          */
199         if (!scsi_block_when_processing_errors(sdev))
200                 return -ENODEV;
201 
202         /* Check for deprecated ioctls ... all the ioctls which don't
203          * follow the new unique numbering scheme are deprecated */
204         switch (cmd) {
205         case SCSI_IOCTL_SEND_COMMAND:
206         case SCSI_IOCTL_TEST_UNIT_READY:
207         case SCSI_IOCTL_BENCHMARK_COMMAND:
208         case SCSI_IOCTL_SYNC:
209         case SCSI_IOCTL_START_UNIT:
210         case SCSI_IOCTL_STOP_UNIT:
211                 printk(KERN_WARNING "program %s is using a deprecated
SCSI "
212                        "ioctl, please convert it to SG_IO\n",
current->comm);
213                 break;
214         default:
215                 break;
216         }
217 
218         switch (cmd) {
219         case SCSI_IOCTL_GET_IDLUN:
220                 if (!access_ok(VERIFY_WRITE, arg, sizeof(struct
scsi_idlun)))
221                         return -EFAULT;
222 
223                 __put_user((sdev->id & 0xff)
224                          + ((sdev->lun & 0xff) << 8)
225                          + ((sdev->channel & 0xff) << 16)
226                          + ((sdev->host->host_no & 0xff) << 24),
227                          &((struct scsi_idlun __user *)arg)->dev_id);
228                 __put_user(sdev->host->unique_id,
229                          &((struct scsi_idlun __user
*)arg)->host_unique_id);
230                 return 0;
231         case SCSI_IOCTL_GET_BUS_NUMBER:
232                 return put_user(sdev->host->host_no, (int __user *)arg);
233         case SCSI_IOCTL_PROBE_HOST:
234                 return ioctl_probe(sdev->host, arg);
235         case SCSI_IOCTL_SEND_COMMAND:
236                 if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
237                         return -EACCES;
238                 return sg_scsi_ioctl(NULL, sdev->request_queue, NULL,
arg);
239         case SCSI_IOCTL_DOORLOCK:
240                 return scsi_set_medium_removal(sdev,
SCSI_REMOVAL_PREVENT);
241         case SCSI_IOCTL_DOORUNLOCK:
242                 return scsi_set_medium_removal(sdev,
SCSI_REMOVAL_ALLOW);
243         case SCSI_IOCTL_TEST_UNIT_READY:
244                 return scsi_test_unit_ready(sdev, IOCTL_NORMAL_TIMEOUT,
245                                             NORMAL_RETRIES);
246         case SCSI_IOCTL_START_UNIT:
247                 scsi_cmd[0] = START_STOP;
248                 scsi_cmd[1] = 0;
249                 scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
250                 scsi_cmd[4] = 1;
251                 return ioctl_internal_command(sdev, scsi_cmd,
252                                      START_STOP_TIMEOUT,
NORMAL_RETRIES);
253         case SCSI_IOCTL_STOP_UNIT:
254                 scsi_cmd[0] = START_STOP;
255                 scsi_cmd[1] = 0;
256                 scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
257                 scsi_cmd[4] = 0;
258                 return ioctl_internal_command(sdev, scsi_cmd,
259                                      START_STOP_TIMEOUT,
NORMAL_RETRIES);
260         case SCSI_IOCTL_GET_PCI:
261                 return scsi_ioctl_get_pci(sdev, arg);
262         default:
263                 if (sdev->host->hostt->ioctl)
264                         return sdev->host->hostt->ioctl(sdev, cmd, arg);
265         }
266         return -EINVAL;
267 }
268 EXPORT_SYMBOL(scsi_ioctl);

Your help is appreciated.

Thanks & Regards
Masthan
-- 
View this message in context: http://www.nabble.com/program-inquiry-is-using-a-deprecated-scsi_ioctl-%2C-please-convert-it-to-SG_IO-tf3192438.html#a8862659
Sent from the linux-scsi mailing list archive at Nabble.com.

